/* SPDX-License-Identifier: Apache-2.0 */

#include <assert.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#ifdef MCTP_HAVE_FILEIO
#include <fcntl.h>
#endif

#define pr_fmt(x) "smbus: " x

#include <i2c/smbus.h>
#include <linux/i2c-dev.h>
#include <linux/i2c.h>
#include <sys/ioctl.h>

#include "libmctp-alloc.h"
#include "libmctp-log.h"
#include "libmctp-smbus.h"
#include "libmctp.h"

struct mctp_binding_smbus {
	struct mctp_binding binding;
	int out_fd;
	int in_fd;

	unsigned long bus_id;

	/* receive buffer */
	uint8_t rxbuf[1024];
	struct mctp_pktbuf *rx_pkt;

	/* temporary transmit buffer */
	uint8_t txbuf[256];
};

#ifndef container_of
#define container_of(ptr, type, member)                                        \
	(type *)((char *)(ptr) - (char *)&((type *)0)->member)
#endif

#define binding_to_smbus(b) container_of(b, struct mctp_binding_smbus, binding)

#define MCTP_COMMAND_CODE 0x0F
#define MCTP_SLAVE_ADDRESS 0x1d
#define MCTP_SOURCE_SLAVE_ADDRESS 0x21

#define SMBUS_PEC_BYTE_SIZE 1
#define SMBUS_COMMAND_CODE_SIZE 1
#define SMBUS_LENGTH_FIELD_SIZE 1
#define SMBUS_ADDR_OFFSET_SLAVE 0x1000

struct mctp_smbus_header_tx {
	uint8_t source_slave_address;
};

struct mctp_smbus_header_rx {
	uint8_t destination_slave_address;
	uint8_t command_code;
	uint8_t byte_count;
	uint8_t source_slave_address;
};

#define POLYCHECK (0x1070U << 3)
static uint8_t crc8_calculate(uint16_t d)
{
	int i;

	for (i = 0; i < 8; i++) {
		if (d & 0x8000) {
			d = d ^ POLYCHECK;
		}
		d = d << 1;
	}

	return (uint8_t)(d >> 8);
}

/* Incremental CRC8 over count bytes in the array pointed to by p */
static uint8_t pec_calculate(uint8_t crc, uint8_t *p, size_t count)
{
	int i;

	for (i = 0; i < count; i++) {
		crc = crc8_calculate((crc ^ p[i]) << 8);
	}

	return crc;
}

static uint8_t calculate_pec_byte(uint8_t *buf, size_t len, uint8_t address,
				  uint16_t flags)
{
	uint8_t addr = (address << 1) | (flags & I2C_M_RD ? 1 : 0);
	uint8_t pec = pec_calculate(0, &addr, 1);
	pec = pec_calculate(pec, buf, len);

	return pec;
}

static int mctp_smbus_tx(struct mctp_binding_smbus *smbus, uint8_t len)
{

#ifdef I2C_M_HOLD
	/* Hold message */
	static uint16_t holdtimeout = 1000; // timeout in ms.
	struct i2c_msg msg[2] =
#else  // !I2C_M_HOLD
	struct i2c_msg msg[1] =
#endif // I2C_M_HOLD
		{{.addr = MCTP_SLAVE_ADDRESS,
		  .flags = 0,
		  .len = len,
		  .buf = (__uint8_t *)smbus->txbuf}
#ifdef I2C_M_HOLD
		 ,
		 {.addr = 0,
		  .flags = I2C_M_HOLD,
		  .len = sizeof(holdtimeout),
		  .buf = (__uint8_t *)&holdtimeout}
#endif // I2C_M_HOLD
		};

#ifdef I2C_M_HOLD
	struct i2c_rdwr_ioctl_data msgrdwr = {&msg, 2};
#else  // !I2C_M_HOLD
	struct i2c_rdwr_ioctl_data msgrdwr = {&msg, 1};
#endif // I2C_M_HOLD

	return ioctl(smbus->out_fd, I2C_RDWR, &msgrdwr);
}

#ifdef I2C_M_HOLD
static int mctp_smbus_unhold_bus(struct mctp_binding_smbus *smbus)
{
	/* Unhold message */
	static uint16_t holdtimeout = 0; // unhold
	struct i2c_msg holdmsg = {0, I2C_M_HOLD, sizeof(holdtimeout),
				  (__uint8_t *)&holdtimeout};

	struct i2c_rdwr_ioctl_data msgrdwr = {&holdmsg, 1};

	return ioctl(smbus->out_fd, I2C_RDWR, &msgrdwr);
}
#endif // I2C_M_HOLD

static int mctp_binding_smbus_tx(struct mctp_binding *b,
				 struct mctp_pktbuf *pkt)
{
	struct mctp_binding_smbus *smbus = binding_to_smbus(b);
	struct mctp_smbus_header_tx *hdr;
	size_t pkt_length;

	uint8_t i2c_message_buf[256];
	uint8_t *buf_ptr;
	uint8_t i2c_message_len;

	uint16_t timeout = 1000;

	/* the length field in the header excludes smbus framing
	 * and escape sequences */
	pkt_length = mctp_pktbuf_size(pkt);

	buf_ptr = (void *)smbus->txbuf;
	*buf_ptr = MCTP_COMMAND_CODE;
	buf_ptr++;
	*buf_ptr = pkt_length + sizeof(*hdr);
	buf_ptr++;

	hdr = (void *)buf_ptr;
	hdr->source_slave_address = MCTP_SOURCE_SLAVE_ADDRESS;
	buf_ptr = (buf_ptr + sizeof(*hdr));
	memcpy(buf_ptr, &pkt->data[pkt->start], pkt_length);
	buf_ptr = buf_ptr + pkt_length;

	uint8_t pec_byte = calculate_pec_byte(
		smbus->txbuf,
		SMBUS_COMMAND_CODE_SIZE + SMBUS_LENGTH_FIELD_SIZE + sizeof(*hdr)
			+ pkt_length,
		MCTP_SLAVE_ADDRESS, 0);

	*buf_ptr = pec_byte;

	i2c_message_len = SMBUS_COMMAND_CODE_SIZE + SMBUS_LENGTH_FIELD_SIZE
			  + sizeof(*hdr) + pkt_length
			  + SMBUS_PEC_BYTE_SIZE; // command code, length,
						 // header, data, pec byte

	if (mctp_smbus_tx(smbus, i2c_message_len)) {
		mctp_prerr("Can't hold mux");
		return -1;
	}

	return 0;
}

#ifdef MCTP_HAVE_FILEIO
int mctp_smbus_read(struct mctp_binding_smbus *smbus)
{
	ssize_t len = 0;
	struct mctp_smbus_header_rx *hdr;
	int ret = 0;

	do {
		ret = lseek(smbus->in_fd, 0, SEEK_SET);
		if (ret < 0) {
			mctp_prerr("Failed to seek");
			ret = -1;
		}

		len = read(smbus->in_fd, smbus->rxbuf, sizeof(smbus->rxbuf));
		if (len < sizeof(*hdr)) {
			// This condition hits from from time to time, even with
			// a properly written poll loop, although it's not clear
			// why. Return an error so that the upper layer can
			// retry.
			ret = 0;
			break;
		}

		hdr = (void *)smbus->rxbuf;
		if (hdr->destination_slave_address
		    != (MCTP_SOURCE_SLAVE_ADDRESS & ~1)) {
			mctp_prerr("Got bad slave address %d",
				   hdr->destination_slave_address);
			ret = 0;
			break;
		}
		if (hdr->command_code != MCTP_COMMAND_CODE) {
			mctp_prerr("Got bad command code %d",
				   hdr->command_code);
			// Not a payload intended for us
			ret = 0;
			break;
		}

		if (hdr->byte_count != (len - sizeof(*hdr))) {
			// Got an incorrectly sized payload
			mctp_prerr("Got smbus payload sized %d, expecting %d",
				   hdr->byte_count, len - sizeof(*hdr));
			ret = 0;
			break;
		}

		if (len < 0) {
			mctp_prerr("can't read from smbus device: %m");
			ret = -1;
			break;
		}

		smbus->rx_pkt = mctp_pktbuf_alloc(&(smbus->binding), 0);
		assert(smbus->rx_pkt);

		if (mctp_pktbuf_push(smbus->rx_pkt, &smbus->rxbuf[sizeof(*hdr)],
				     len - sizeof(*hdr) - SMBUS_PEC_BYTE_SIZE)
		    != 0) {
			mctp_prerr("Can't push tok pktbuf: %m");
			ret = -1;
			break;
		}

		mctp_bus_rx(&(smbus->binding), smbus->rx_pkt);

		smbus->rx_pkt = NULL;

	} while (0);

#ifdef I2C_M_HOLD
	if (mctp_smbus_unhold_bus(smbus)) {
		mctp_prerr("Can't hold mux");
		ret = -1;
	}
#endif // I2C_M_HOLD

	return ret;
}

int mctp_smbus_get_in_fd(struct mctp_binding_smbus *smbus)
{
	return smbus->in_fd;
}


int mctp_smbus_set_in_fd(struct mctp_binding_smbus *smbus, int fd)
{
	smbus->in_fd = fd;
}

int mctp_smbus_set_out_fd(struct mctp_binding_smbus *smbus, int fd)
{
	smbus->out_fd = fd;
}

int mctp_smbus_get_out_fd(struct mctp_binding_smbus *smbus)
{
	return smbus->out_fd;
}

int mctp_smbus_open_in_bus(struct mctp_binding_smbus *smbus, int in_bus)
{
	char filename[60];
	size_t filename_size = 0;
	char slave_mqueue[20];
	size_t mqueue_size = 0;
	int fd = 0;
	size_t size = sizeof(filename);
	int address_7_bit = MCTP_SOURCE_SLAVE_ADDRESS >> 1;
	int ret = -1;

	snprintf(filename, size,
		 "/sys/bus/i2c/devices/i2c-%d/%d-%04x/slave-mqueue", in_bus,
		 in_bus, SMBUS_ADDR_OFFSET_SLAVE | address_7_bit);

	ret = open(filename, O_RDONLY | O_NONBLOCK | O_CLOEXEC);
	if (ret >= 0) {
		return ret;
	}

	// Device doesn't exist.  Create it.
	filename_size = sizeof(filename);
	snprintf(filename, filename_size,
		 "/sys/bus/i2c/devices/i2c-%d/new_device", in_bus);
	filename[filename_size - 1] = '\0';

	fd = open(filename, O_WRONLY);
	if (fd < 0) {
		mctp_prerr("can't open root device %s: %m", filename);
		return -1;
	}

	mqueue_size = sizeof(slave_mqueue);
	snprintf(slave_mqueue, mqueue_size, "slave-mqueue %#04x",
		 SMBUS_ADDR_OFFSET_SLAVE | address_7_bit);

	size = write(fd, slave_mqueue, mqueue_size);
	close(fd);
	if (size != mqueue_size) {
		mctp_prerr("can't create mqueue device on %s: %m", filename);
		return -1;
	}

	size = sizeof(filename);
	snprintf(filename, size,
		 "/sys/bus/i2c/devices/i2c-%d/%d-%04x/slave-mqueue", in_bus,
		 in_bus, SMBUS_ADDR_OFFSET_SLAVE | address_7_bit);

	return open(filename, O_RDONLY | O_NONBLOCK | O_CLOEXEC);
}

int mctp_smbus_open_out_bus(struct mctp_binding_smbus *smbus, int out_bus)
{
	char filename[60];
	size_t size = sizeof(filename);
	snprintf(filename, size, "/dev/i2c-%d", out_bus);
	filename[size - 1] = '\0';

	return open(filename, O_RDWR | O_NONBLOCK);
}

/*
int mctp_smbus_open_bus(struct mctp_binding_smbus *smbus, int out_bus_num,
			int root_bus_num)
{
	char filename[60];
	size_t filename_size = 0;
	char slave_mqueue[20];
	size_t mqueue_size = 0;
	int fd = 0;
	size_t size = sizeof(filename);
	int address_7_bit = MCTP_SOURCE_SLAVE_ADDRESS >> 1;

	snprintf(filename, size,
		 "/sys/bus/i2c/devices/i2c-%d/%d-%04x/slave-mqueue",
		 root_bus_num, root_bus_num,
		 SMBUS_ADDR_OFFSET_SLAVE | address_7_bit);

	smbus->in_fd = open(filename, O_RDONLY | O_NONBLOCK | O_CLOEXEC);
	if (smbus->in_fd < 0) {
		// Device doesn't exist.  Create it.
		filename_size = sizeof(filename);
		snprintf(filename, filename_size,
			 "/sys/bus/i2c/devices/i2c-%d/new_device",
			 root_bus_num);
		filename[filename_size - 1] = '\0';

		fd = open(filename, O_WRONLY);
		if (fd < 0) {
			mctp_prerr("can't open root device %s: %m", filename);
			return -1;
		}

		mqueue_size = sizeof(slave_mqueue);
		snprintf(slave_mqueue, mqueue_size, "slave-mqueue %#04x",
			 SMBUS_ADDR_OFFSET_SLAVE | address_7_bit);

		size = write(fd, slave_mqueue, mqueue_size);
		close(fd);
		if (size != mqueue_size) {
			mctp_prerr("can't create mqueue device on %s: %m",
				   filename);
			return -1;
		}

		size = sizeof(filename);
		snprintf(filename, size,
			 "/sys/bus/i2c/devices/i2c-%d/%d-%04x/slave-mqueue",
			 root_bus_num, root_bus_num,
			 SMBUS_ADDR_OFFSET_SLAVE | address_7_bit);

		smbus->in_fd =
			open(filename, O_RDONLY | O_NONBLOCK | O_CLOEXEC);
		if (smbus->in_fd < 0) {
			mctp_prerr("can't open mqueue device on %s: %m",
				   filename);
			return -2;
		}
	}

	size = sizeof(filename);
	snprintf(filename, size, "/dev/i2c-%d", out_bus_num);
	filename[size - 1] = '\0';

	smbus->out_fd = open(filename, O_RDWR | O_NONBLOCK);
	if (smbus->out_fd < 0) {
		close(smbus->in_fd);
		mctp_prerr("can't open device %s: %m", filename);
	}

	return 0;
}
*/
#endif

void mctp_smbus_register_bus(struct mctp_binding_smbus *smbus,
			     struct mctp *mctp, mctp_eid_t eid)
{
	smbus->bus_id = mctp_register_bus(mctp, &smbus->binding, eid);
	mctp_binding_set_tx_enabled(&smbus->binding, true);
}

struct mctp_binding_smbus *mctp_smbus_init(void)
{
	struct mctp_binding_smbus *smbus;

	smbus = __mctp_alloc(sizeof(*smbus));
	memset(&(smbus->binding), 0, sizeof(smbus->binding));

	smbus->in_fd = -1;
	smbus->out_fd = -1;

	smbus->rx_pkt = NULL;
	smbus->binding.name = "smbus";
	smbus->binding.version = 1;
	smbus->binding.pkt_size = sizeof(smbus->rxbuf);

	smbus->binding.tx = mctp_binding_smbus_tx;
	return smbus;
}

void mctp_smbus_free(struct mctp_binding_smbus *smbus)
{
	__mctp_free(smbus);
}

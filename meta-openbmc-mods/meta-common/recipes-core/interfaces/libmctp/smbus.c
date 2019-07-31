/* SPDX-License-Identifier: Apache-2.0 */

#include <assert.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#ifdef MCTP_FILEIO
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
	struct mctp *mctp;
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

struct mctp_smbus_header_tx {
	uint8_t source_slave_address;
};

struct mctp_smbus_header_rx {
	uint8_t destination_slave_address;
	uint8_t command_code;
	uint8_t byte_count;
	uint8_t source_slave_address;
};

static int mctp_binding_smbus_tx(struct mctp_binding *b,
				 struct mctp_pktbuf *pkt)
{
	struct mctp_binding_smbus *smbus = binding_to_smbus(b);
	struct mctp_smbus_header_tx *hdr;
	uint8_t *buf;
	size_t len;
	int r;
	struct i2c_msg msg;
	struct i2c_rdwr_ioctl_data data;

	data.msgs = &msg;
	data.nmsgs = 1;

	uint16_t timeout = 1000;
	int i;

	/* the length field in the header excludes smbus framing
	 * and escape sequences */
	len = mctp_pktbuf_size(pkt);

	hdr = (void *)smbus->txbuf;

	// hdr->len = len + 1;  // +1 for PET byte
	hdr->source_slave_address = MCTP_SOURCE_SLAVE_ADDRESS;

	buf = (void *)(hdr + sizeof(*hdr));

	if (len + sizeof(*hdr) > sizeof(smbus->txbuf))
		return -1;

	memcpy(buf, &pkt->data[pkt->start], len);

	buf += len;

	if (ioctl(smbus->out_fd, I2C_SLAVE, MCTP_SLAVE_ADDRESS) < 0) {
		mctp_prerr("Can't set slave");
		return -1;
	}
	if (ioctl(smbus->out_fd, I2C_PEC, 1) < 0) {
		mctp_prerr("Cant set PEC byte");
		return -1;
	}

	if (i2c_smbus_write_block_data(smbus->out_fd, MCTP_COMMAND_CODE,
				       sizeof(*hdr) + len, (void *)smbus->txbuf)
	    < 0) {
		mctp_prerr("Failed to send");
		return -1;
	}

	return 0;
}

#ifdef MCTP_FILEIO
int mctp_smbus_read(struct mctp_binding_smbus *smbus)
{
	ssize_t len;
	int r;
	struct mctp_smbus_header_rx *hdr;

	r = lseek(smbus->in_fd, 0, SEEK_SET);
	if (r < 0) {
		mctp_prerr("Failed to seek");
		return -1;
	}
	len = read(smbus->in_fd, smbus->rxbuf, sizeof(smbus->rxbuf));
	if (len < sizeof(*hdr)) {
		// TODO Don't return an error here, as it seems to happen from
		// time to time, even with a properly written poll loop,
		// although it's not clear why.
		return 0;
	}

	hdr = (void *)smbus->rxbuf;
	if (hdr->destination_slave_address
	    != (MCTP_SOURCE_SLAVE_ADDRESS & ~1)) {
		mctp_prerr("Got bad slave address %d",
			   hdr->destination_slave_address);
		return 0;
	}
	if (hdr->command_code != MCTP_COMMAND_CODE) {
		mctp_prerr("Got bad command code %d", hdr->command_code);
		// Not a payload intended for us
		return 0;
	}

	if (hdr->byte_count != (len - sizeof(*hdr))) {
		// Got an incorrectly sized payload
		mctp_prerr("Got smbus payload sized %d, expecting %d",
			   hdr->byte_count, len - sizeof(*hdr));
		return 0;
	}

	if (len < 0) {
		mctp_prerr("can't read from smbus device: %m");
		return -1;
	}

	smbus->rx_pkt = mctp_pktbuf_alloc(0);
	assert(smbus->rx_pkt);

	if (mctp_pktbuf_push(smbus->rx_pkt, &smbus->rxbuf[sizeof(*hdr)],
			     len - sizeof(*hdr) - SMBUS_PEC_BYTE_SIZE)
	    != 0) {
		mctp_prerr("Can't push tok pktbuf: %m");
		return -1;
	}

	mctp_bus_rx(&(smbus->binding), smbus->rx_pkt);

	mctp_pktbuf_free(smbus->rx_pkt);
	smbus->rx_pkt = NULL;

	return 0;
}

int mctp_smbus_get_in_fd(struct mctp_binding_smbus *smbus)
{
	return smbus->in_fd;
}

int mctp_smbus_get_out_fd(struct mctp_binding_smbus *smbus)
{
	return smbus->out_fd;
}

int mctp_smbus_open_bus(struct mctp_binding_smbus *smbus, int out_bus_num,
			int root_bus_num)
{
	char filename[60];
	size_t filename_size;
	char slave_mqueue[20];
	size_t mqueue_size;

	int fd;

	size_t size;
	int address_7_bit;

	address_7_bit = MCTP_SOURCE_SLAVE_ADDRESS >> 1;
	size = sizeof(filename);
	snprintf(filename, size,
		 "/sys/bus/i2c/devices/i2c-%d/%d-%04x/slave-mqueue",
		 root_bus_num, root_bus_num,
		 (address_7_bit << 8) + address_7_bit);

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
			 (address_7_bit << 8) + address_7_bit);

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
			 (address_7_bit << 8) + address_7_bit);

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

#endif

void mctp_smbus_register_bus(struct mctp_binding_smbus *smbus,
			     struct mctp *mctp, mctp_eid_t eid)
{
	assert(smbus->out_fd >= 0);
	assert(smbus->in_fd >= 0);
	smbus->mctp = mctp;
	smbus->bus_id = mctp_register_bus(mctp, &smbus->binding, eid);
}

struct mctp_binding_smbus *mctp_smbus_init(void)
{
	struct mctp_binding_smbus *smbus;

	smbus = __mctp_alloc(sizeof(*smbus));
	smbus->in_fd = -1;
	smbus->out_fd = -1;

	smbus->rx_pkt = NULL;
	smbus->binding.name = "smbus";
	smbus->binding.version = 1;

	smbus->binding.tx = mctp_binding_smbus_tx;

	return smbus;
}

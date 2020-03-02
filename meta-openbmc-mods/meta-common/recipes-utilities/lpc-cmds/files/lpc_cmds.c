/*
// Copyright (c) 2017 Intel Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
//
*/

#include <stdio.h>
#include <time.h>
#include <unistd.h>
#include <stdlib.h>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <sys/mman.h>

#include "lpc_drv.h"

#define SIO_DEVICE_NAME		"/dev/lpc-sio"
#define KCS_DEVICE_NAME		"/dev/ipmi-kcs"
#define MAILBOX_DEVICE_NAME	"/dev/aspeed-mbox"
#define SNOOP_DEVICE_NAME	"/dev/aspeed-lpc-snoop"

#define SNOOP_BUF_SIZE		4096

#define SUPPORT_KCS_ADDR_CMD	0
#define SUPPORT_MAILBOX		1
#define SUPPORT_SNOOP		1

/*********************************************************************************/
static void ProcessKCSReq(int fd, unsigned char *pReq, int ReqLen, int NoPrint)
{
	int i;
	unsigned char SendPkt[16];

	if (!NoPrint) {
		printf("\nKCS Request >>>>>>>>>>>>>>>>>>>>>>>>>>\n");
		for (i = 0; i < ReqLen; i++)
			printf("%02X ", pReq[i]);
		printf("\n======================================\n");
	}

	SendPkt[0] = pReq[0] | 0x04;
	SendPkt[1] = pReq[1];
	SendPkt[2] = 0xC1;		/* Always Invalid Command */

	if (!NoPrint) {
		printf("\nKCS Response <<<<<<<<<<<<<<<<<<<<<<<<<\n");
		for (i = 0; i < 3; i++)
			printf("%02X ", SendPkt[i]);
		printf("\n======================================\n");
	}

	write(fd, SendPkt, 3);
}

static void KCSIfcTask(int KCSIfcIdx, int NoPrint)
{
	int fd;
	int RecvPktLen;
	char KCSDev[16];
	struct kcs_ioctl_data IOData;
	unsigned char RecvPkt[512];

	snprintf(KCSDev, sizeof(KCSDev), KCS_DEVICE_NAME"%d", KCSIfcIdx);
	fd = open(KCSDev, O_RDWR | O_CLOEXEC);
	if (fd < 0) {
		printf("Error open KCS device: %s\n", KCSDev);
		exit(1);
	}

	IOData.cmd  = KCS_FORCE_ABORT;
	IOData.data = 0;
	ioctl(fd, KCS_IOC_COMMAND, &IOData);

	while (1) {
		RecvPktLen = read(fd, RecvPkt, sizeof(RecvPkt));
		if (RecvPktLen < 2)
			continue;

		ProcessKCSReq(fd, RecvPkt, RecvPktLen, NoPrint);
	}
}

#if SUPPORT_KCS_ADDR_CMD
static void KCSIfcSetAddr(int KCSIfcIdx, unsigned int addr)
{
	int fd;
	struct kcs_ioctl_data kcs_data;
	char KCSDev[16];

	snprintf(KCSDev, sizeof(KCSDev), KCS_DEVICE_NAME"%d", KCSIfcIdx);
	fd = open(KCSDev, O_RDWR | O_CLOEXEC);
	if (fd < 0) {
		printf("Error open KCS device: %s\n", KCSDev);
		exit(1);
	}

	kcs_data.cmd  = KCS_SET_ADDR;
	kcs_data.data = addr;
	if (ioctl(fd, KCS_IOC_COMMAND, &kcs_data) == 0)
		printf("Set KCS%d addr to 0x%X successfully!\n", KCSIfcIdx + 1, addr);

	close(fd);
}

static void KCSIfcGetAddr(int KCSIfcIdx)
{
	int fd;
	struct kcs_ioctl_data kcs_data;
	char KCSDev[16];

	snprintf(KCSDev, sizeof(KCSDev), KCS_DEVICE_NAME"%d", KCSIfcIdx);
	fd = open(KCSDev, O_RDWR | O_CLOEXEC);
	if (fd < 0) {
		printf("Error open KCS device: %s\n", KCSDev);
		exit(1);
	}

	kcs_data.cmd = KCS_GET_ADDR;
	if (ioctl(fd, KCS_IOC_COMMAND, &kcs_data) == 0)
		printf("KCS%d addr is : 0x%X!\n", KCSIfcIdx + 1, kcs_data.data);

	close(fd);
}
#endif

/*********************************************************************************/

#if SUPPORT_SNOOP
static void ReadBiosPOSTCodes(unsigned int if_idx)
{
	char snoop_dev[32];
	int fd;
	int i;
	unsigned char buf[SNOOP_BUF_SIZE];
	int len;

	snprintf(snoop_dev, sizeof(snoop_dev), SNOOP_DEVICE_NAME"%d", if_idx);
	fd = open(snoop_dev, O_RDONLY | O_NONBLOCK | O_CLOEXEC);
	if (fd < 0) {
		printf("Error open %s !\n", snoop_dev);
		return;
	}

	len = read(fd, &buf, sizeof(buf));

	if (len == 0 || errno == EAGAIN) {
		printf("No BIOS POST Codes Found!\n");
		goto out;
	} else if (len < 0) {
		printf("Failed to read the POST Codes! (%s)\n",
		       strerror(errno));
		goto out;
	}

	printf("BIOS POST Codes in Hex (%d entries):\n", len);

	for (i = 0; i < len; i++)
		printf(" %d: %02X\n", i, buf[i]);

	printf("\n");

out:
	close(fd);
}
#endif

/*********************************************************************************/

static void SIOGetACPIState(unsigned short changed)
{
	int fd;
	struct sio_ioctl_data sio_data;

	fd = open(SIO_DEVICE_NAME, O_RDWR | O_CLOEXEC);
	if (fd < 0) {
		printf("Error open %s\n", SIO_DEVICE_NAME);
		exit(1);
	}

	sio_data.sio_cmd = SIO_GET_ACPI_STATE;
	sio_data.param   = changed;

	if (ioctl(fd, SIO_IOC_COMMAND, &sio_data) == 0) {
		if (changed)
			printf("ACPI SLP state is %s!\n",
				sio_data.param != 0 ? "Changed" : "Same");

		if (sio_data.data == ACPI_STATE_S12)
			printf("ACPI SLP state --> SLP_12\n");
		else if (sio_data.data == ACPI_STATE_S3I)
			printf("ACPI SLP state --> SLP_3I\n");
		else if (sio_data.data == ACPI_STATE_S45)
			printf("ACPI SLP state --> SLP_45\n");
	}

	close(fd);
}

static void SIOGetPWRGDStatus(unsigned short changed)
{
	int fd;
	struct sio_ioctl_data sio_data;

	fd = open(SIO_DEVICE_NAME, O_RDWR | O_CLOEXEC);
	if (fd < 0) {
		printf("Error open %s\n", SIO_DEVICE_NAME);
		exit(1);
	}

	sio_data.sio_cmd = SIO_GET_PWRGD_STATUS;
	sio_data.param   = changed;

	if (ioctl(fd, SIO_IOC_COMMAND, &sio_data) == 0) {
		if (changed)
			printf("PWRGD status : %s\n",
					sio_data.param != 0 ? "Changed" : "Same");

		printf("PWRGD status value :%u\n", sio_data.data);
	}

	close(fd);
}

static void SIOGetONCTLStatus(void)
{
	int fd;
	struct sio_ioctl_data sio_data;

	fd = open(SIO_DEVICE_NAME, O_RDWR | O_CLOEXEC);
	if (fd < 0) {
		printf("Error open %s\n", SIO_DEVICE_NAME);
		exit(1);
	}

	sio_data.sio_cmd = SIO_GET_ONCTL_STATUS;

	if (ioctl(fd, SIO_IOC_COMMAND, &sio_data) == 0)
		printf("ONCTL status value :%u\n", sio_data.data);

	close(fd);
}

static void SIOSetONCTLGPIO(unsigned short enable, unsigned int value)
{
	int fd;
	struct sio_ioctl_data sio_data;

	fd = open(SIO_DEVICE_NAME, O_RDWR | O_CLOEXEC);
	if (fd < 0) {
		printf("Error open %s\n", SIO_DEVICE_NAME);
		exit(1);
	}

	sio_data.sio_cmd = SIO_SET_ONCTL_GPIO;
	sio_data.param   = enable;
	sio_data.data    = value;

	if (ioctl(fd, SIO_IOC_COMMAND, &sio_data) == 0)
		printf("ONCTL GPIO mode setting is Done!\n");

	close(fd);
}

static void SIOGetPWRBTNOverride(unsigned short clear)
{
	int fd;
	struct sio_ioctl_data sio_data;

	fd = open(SIO_DEVICE_NAME, O_RDWR | O_CLOEXEC);
	if (fd < 0) {
		printf("Error open %s\n", SIO_DEVICE_NAME);
		exit(1);
	}

	sio_data.sio_cmd = SIO_GET_PWRBTN_OVERRIDE;
	sio_data.param   = clear;

	if (ioctl(fd, SIO_IOC_COMMAND, &sio_data) == 0)
		printf("PWRBTN Override status : %u\n", sio_data.data);

	close(fd);
}

static void SIOGetPFailStatus()
{
	int fd;
	struct sio_ioctl_data sio_data;

	fd = open(SIO_DEVICE_NAME, O_RDWR | O_CLOEXEC);
	if (fd < 0) {
		printf("Error open %s\n", SIO_DEVICE_NAME);
		exit(1);
	}

	sio_data.sio_cmd = SIO_GET_PFAIL_STATUS;

	if (ioctl(fd, SIO_IOC_COMMAND, &sio_data) == 0)
		printf("PFail status : %u\n", sio_data.data);

	close(fd);
}

static void SIOSetBMCSCIEvent(unsigned short set)
{
	int fd;
	struct sio_ioctl_data sio_data;

	fd = open(SIO_DEVICE_NAME, O_RDWR | O_CLOEXEC);
	if (fd < 0) {
		printf("Error open %s\n", SIO_DEVICE_NAME);
		exit(1);
	}

	sio_data.sio_cmd = SIO_SET_BMC_SCI_EVENT;
	sio_data.param   = set;

	if (ioctl(fd, SIO_IOC_COMMAND, &sio_data) == 0)
		printf("BMC SCI event is %s\n",
		       sio_data.data ? "set" : "cleared");

	close(fd);
}

/*********************************************************************************/

#if SUPPORT_MAILBOX
static void MailBoxRead(int num)
{
	int fd;
	int len;
	uint8_t data;

	fd = open(MAILBOX_DEVICE_NAME, O_RDWR | O_NONBLOCK | O_CLOEXEC);
	if (fd < 0) {
		printf("Error open mailbox\n");
		exit(1);
	}

	len = pread(fd, &data, 1, num);
	if (len == 0 || errno == EAGAIN) {
		printf("No mailbox message found!\n");
		goto out;
	} else if (len < 0) {
		printf("Error reading from mailbox%d! (%s)\n", num,
		       strerror(errno));
		goto out;
	}

	printf("MailBox%d read value : 0x%02X\n", num, data);

out:
	close(fd);
}

static void MailBoxWrite(int num, uint8_t value)
{
	int fd;
	ssize_t rc;

	fd = open(MAILBOX_DEVICE_NAME, O_RDWR | O_NONBLOCK | O_CLOEXEC);
	if (fd < 0) {
		printf("Error open mailbox\n");
		exit(1);
	}

	rc = pwrite(fd, &value, 1, num);

	if (rc == 1)
		printf("MailBox%d write value : 0x%02X done!\n", num, value);
	else
		printf("Error writing to mailbox%d, rc: %d\n", num, rc);

	close(fd);
}
#endif

/*********************************************************************************/

static void usage(void)
{
	printf("Usage:\n"
	       "\tlpc_cmds sio get_acpi_state\n"
	       "\tlpc_cmds sio get_acpi_changed\n"
	       "\tlpc_cmds sio get_pwrgd_status\n"
	       "\tlpc_cmds sio get_pwrgd_changed\n"
	       "\tlpc_cmds sio get_onctl_status\n"
	       "\tlpc_cmds sio set_onctl_gpio_disable\n"
	       "\tlpc_cmds sio set_onctl_gpio_high\n"
	       "\tlpc_cmds sio set_onctl_gpio_low\n"
	       "\tlpc_cmds sio get_pwrbtn_override_status\n"
	       "\tlpc_cmds sio get_pwrbtn_override_status_clear\n"
	       "\tlpc_cmds sio get_pfail_status\n"
	       "\tlpc_cmds sio set_bmc_sci_event\n"
	       "\tlpc_cmds sio clear_bmc_sci_event\n"
	       "\n"
#if SUPPORT_KCS_ADDR_CMD
	       "\tlpc_cmds kcs [1 ~ 4] (getaddr / setaddr / quiet)\n"
#else
	       "\tlpc_cmds kcs [1 ~ 4] (quiet)\n"
#endif
#if SUPPORT_MAILBOX
	       "\n"
	       "\tlpc_cmds mailbox read  (0 ~ 15)\n"
	       "\tlpc_cmds mailbox write (0 ~ 15) (0x00 ~ 0xFF)\n"
#endif
#if SUPPORT_SNOOP
	       "\n"
	       "\tlpc_cmds snoop [0 ~ 1] read\n"
#endif
		);

	exit(-1);
}

int main(int argc, char** argv)
{
	char *cmd;

	if (argc < 2)
		usage();

	cmd = argv[1];

	if (strcmp(cmd, "sio") == 0) {
		if (argc < 3)
			usage();

		if (strcmp(argv[2], "get_acpi_state") == 0)
			SIOGetACPIState(0);
		else if (strcmp(argv[2], "get_acpi_changed") == 0)
			SIOGetACPIState(1);
		else if (strcmp(argv[2], "get_pwrgd_status") == 0)
			SIOGetPWRGDStatus(0);
		else if (strcmp(argv[2], "get_pwrgd_changed") == 0)
			SIOGetPWRGDStatus(1);
		else if (strcmp(argv[2], "get_onctl_status") == 0)
			SIOGetONCTLStatus();
		else if (strcmp(argv[2], "set_onctl_gpio_disable") == 0)
			SIOSetONCTLGPIO(0, 0);
		else if (strcmp(argv[2], "set_onctl_gpio_high") == 0)
			SIOSetONCTLGPIO(1, 1);
		else if (strcmp(argv[2], "set_onctl_gpio_low") == 0)
			SIOSetONCTLGPIO(1, 0);
		else if (strcmp(argv[2], "get_pwrbtn_override_status") == 0)
			SIOGetPWRBTNOverride(0);
		else if (strcmp(argv[2], "get_pwrbtn_override_status_clear") == 0)
			SIOGetPWRBTNOverride(1);
		else if (strcmp(argv[2], "get_pfail_status") == 0)
			SIOGetPFailStatus();
		else if (strcmp(argv[2], "set_bmc_sci_event") == 0)
			SIOSetBMCSCIEvent(1);
		else if (strcmp(argv[2], "clear_bmc_sci_event") == 0)
			SIOSetBMCSCIEvent(0);
	} else if (strcmp(cmd, "kcs") == 0) {
		int ifc;

		if (argc < 3)
			usage();

		ifc = atoi(argv[2]);
		if (ifc < 1 || ifc > 4) /* ipmi-kcs1 ~ ipmi-kcs4 */
			usage();

		if (argc == 3)
			KCSIfcTask(ifc, 0);
		else if (argc == 4 && strcmp(argv[3], "quiet") == 0)
			KCSIfcTask(ifc, 1);
#if SUPPORT_KCS_ADDR_CMD
		else if (argc == 4 && strcmp(argv[3], "getaddr") == 0)
			KCSIfcGetAddr(ifc);
		else if (argc == 5 && strcmp(argv[3], "setaddr") == 0)
			KCSIfcSetAddr(ifc, strtoul(argv[4], NULL, 16));
#endif
#if SUPPORT_MAILBOX
	} else if (strcmp(cmd, "mailbox") == 0) {
		if (argc < 4)
			usage();

		if (strcmp(argv[2], "read") == 0) {
			MailBoxRead(atoi(argv[3]));
		} else {
			if (argc < 5)
				usage();
			MailBoxWrite(atoi(argv[3]), strtoul(argv[4], NULL, 16));
		}
#endif
#if SUPPORT_SNOOP
	} else if (strcmp(cmd, "snoop") == 0) {
		int ifc;

		if (argc < 3)
			usage();

		ifc = atoi(argv[2]);
		if (ifc < 0 || ifc > 1) /* snoop0 ~ snoop1 */
			usage();

		if (strcmp(argv[3], "read") == 0)
			ReadBiosPOSTCodes(ifc);
		else
			usage();
#endif
	}

	return 0;
}


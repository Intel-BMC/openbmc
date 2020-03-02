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

#ifndef __LPC_DRV_H__
#define __LPC_DRV_H__

#define LPC_DEV_MAJOR	250
#define LPC_DEV_MINOR	0

/***********************************************************************************/

enum KCS_CMD {
	KCS_SET_ADDR = 0,
	KCS_GET_ADDR,
	KCS_SMS_ATN,
	KCS_FORCE_ABORT,
};

struct kcs_ioctl_data {
	unsigned int  cmd;
	unsigned int  data;
};

#define KCS_IOC_BASE                   'K'
#define KCS_IOC_COMMAND                _IOWR(KCS_IOC_BASE, 1, struct kcs_ioctl_data)

/***********************************************************************************/

enum ACPI_SLP_STATE {
	ACPI_STATE_S12 = 1,
	ACPI_STATE_S3I,
	ACPI_STATE_S45
};

/* SWC & ACPI for SuperIO IOCTL */
enum SIO_CMD {
	SIO_GET_ACPI_STATE = 0,
	SIO_GET_PWRGD_STATUS,
	SIO_GET_ONCTL_STATUS,
	SIO_SET_ONCTL_GPIO,
	SIO_GET_PWRBTN_OVERRIDE,
	SIO_GET_PFAIL_STATUS, /* Start from AC Loss */
	SIO_SET_BMC_SCI_EVENT,

	SIO_MAX_CMD
};

struct sio_ioctl_data {
	unsigned short sio_cmd;
	unsigned short param;
	unsigned int   data;
};

#define SIO_IOC_BASE            'P'
#define SIO_IOC_COMMAND         _IOWR(SIO_IOC_BASE, 1, struct sio_ioctl_data)

/***********************************************************************************/

#define MAX_MAILBOX_NUM         16

/***********************************************************************************/

#endif


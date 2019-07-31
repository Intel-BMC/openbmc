/* SPDX-License-Identifier: Apache-2.0 */

#ifndef _LIBMCTP_SMBUS_H
#define _LIBMCTP_SMBUS_H

#include "libmctp.h"

struct mctp_binding_smbus;

struct mctp_binding_smbus *mctp_smbus_init(void);
int mctp_smbus_get_out_fd(struct mctp_binding_smbus *smbus);
int mctp_smbus_get_in_fd(struct mctp_binding_smbus *smbus);
void mctp_smbus_register_bus(struct mctp_binding_smbus *smbus,
			     struct mctp *mctp, mctp_eid_t eid);
int mctp_smbus_read(struct mctp_binding_smbus *smbus);
int mctp_smbus_open_bus(struct mctp_binding_smbus *smbus, int out_bus_num,
			int root_bus_num);
#endif /* _LIBMCTP_SMBUS_H */

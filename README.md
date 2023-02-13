# OpenBMC

![Build status](https://dev.azure.com/openbmc/OpenBMC/_apis/build/status/Intel-BMC.openbmc?branchName=intel "Build status")

Intel-BMC/openbmc is a BMC implementation for servers. The purpose is to provide
early access to features and capabilities which have not yet been accepted or
merged in the OpenBMC main project (github.com/openbmc). In due course, all of
the capabilities here will be brought to the OpenBMC project.

For questions not addressed below or addtional support please contact your IBV
or use your Intel support channel.

Some answers to the main questions that tend to get asked: 

### Does this mean that Intel is no longer contributing to the Linux foundation project?

No. This repo is for components that are intended for the eventual
release to the LF OpenBMC project. There are a number of reasons where things
might be checked in here.  For example: functionality that is still under
discussion or in the LF OpenBMC project, features that have not gone through
the level of testing or integration needed to be included in the OpenBMC
project

### Why does this repo exist at all?

Upstreaming changes to the linux kernel, uboot, systemd, yocto, and the various
projects that OpenBMC pulls in requires a significant effort.  While we aspire
to that process being fast, painless, and with minimal rework, the reality is
far from that, and features or functions that require changes across a number
of repos require a coordinated effort, and a single source of function. As a
general rule, this repository loosens the requirements of "form over function"
and prefers to make some simplifying assumptions of BMC capabilities, chipsets,
and required features.

### Can I upstream/release the code from this repository?

It very much depends on the component. While in general the answer ends up
being "yes", prior approval should be granted, as this repo contains future
facing capabilities that may not have been announced yet.  Please email
OpenBMC.Support@intel.com to discuss. Appropriate licenses will be applied to
the portions of this codebase that are approved for upstreaming.

### How to build for Wolf Pass
```bash
export TEMPLATECONF=meta-openbmc-mods/meta-wolfpass/conf
source oe-init-build-env
bitbake intel-platforms
```
### How to build for Intel reference
```bash
export TEMPLATECONF=meta-openbmc-mods/meta-wht/conf
source oe-init-build-env
bitbake intel-platforms
```

### Default User Credentials

To meet Intel security requirements, this OpenBMC implementation will not have
default user credentials enabled by default.

IPMI commands are available to enable the root user for serial console access
and to enable users for IPMI, Redfish, and web access.

There is also a `"debug-tweaks"` feature that can be added to a build to
re-enable the default user credentials.

#### Enable root user

Without `"debug-tweaks"`, the root user is disabled by default.

The following IPMI command can be used to enable the root user.  This root
user allows access to the BMC serial console, but cannot be used to access
IPMI, Redfish, or the web console.

IPMI OEM net function 0x30, command 0x5f.  For root user, the first byte is
0 followed by the password.

For example, to enable the root user with password `0penBmc1`:

```ipmitool raw 0x30 0x5f 0x00 0x30 0x70 0x65 0x6e 0x42 0x6d 0x63 0x31```

#### Enable IPMI, Redfish, and web users

Without `"debug-tweaks"`, there are no IPMI, Redfish, or web users by default.

The standard IPMI commands to set usernames and passwords are supported.
These users allow access to IPMI, Redfish, and the web console, but cannot be
used to access the BMC serial console.

#### debug-tweaks

Debug features, including the default user credentials, can be enabled by
adding the `"debug-tweaks"` feature to the build by including the following
in your `local.conf` file:

```EXTRA_IMAGE_FEATURES += "debug-tweaks"```

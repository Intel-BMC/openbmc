# OpenBMC

![Build status](https://dev.azure.com/openbmc/OpenBMC/_apis/build/status/Intel-BMC.openbmc?branchName=intel "Build status")

Intel-BMC/openbmc is a BMC implementation for servers. The purpose is to provide
early access to features and capabilities which have not yet been accepted or
merged in the OpenBMC main project (github.com/openbmc). In due course, all of
the capabilities here will be brought to the OpenBMC project.

Some answers to the main questions that tend to get asked: 

### Does this mean that Intel is no longer contributing to the Linux foundation project? ###

No. This repo is for components that are intended for the eventual
release to the LF OpenBMC project. There are a number of reasons where things
might be checked in here.  For example: functionality that is still under
discussion or in the LF OpenBMC project, features that have not gone through
the level of testing or integration needed to be included in the OpenBMC
project

### Why does this repo exist at all? ###

Upstreaming changes to the linux kernel, uboot, systemd, yocto, and the various
projects that OpenBMC pulls in requires a significant effort.  While we aspire
to that process being fast, painless, and with minimal rework, the reality is
far from that, and features or functions that require changes across a number
of repos require a coordinated effort, and a single source of function. As a
general rule, this repository loosens the requirements of "form over function"
and prefers to make some simplifying assumptions of BMC capabilities, chipsets,
and required features.

### Can I upstream/release the code from this repository? ###

It very much depends on the component. While in general the answer ends up
being "yes", prior approval should be granted, as this repo contains future
facing capabilities that may not have been announced yet.  Please email
openbmc@intel.com to discuss. Appropriate licenses will be applied to the
portions of this codebase that are approved for upstreaming.

### Which platforms does this code work on? ###

While the code is easily portable across different type of IA platforms,
currently we use Intel’s Wolf Pass (S2600WP) platform for development and most
testing. 

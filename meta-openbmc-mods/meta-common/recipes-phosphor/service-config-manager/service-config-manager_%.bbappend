inherit meson pkgconfig systemd
SRC_URI = "git://github.com/openbmc/service-config-manager;nobranch=1"
# Move to latest version, only when sdbusplus is bumped up
SRCREV = "0f2b1414d0dda4534008fc5eb0e939d99287c0eb"



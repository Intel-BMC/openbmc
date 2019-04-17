FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

#SRC_URI = "git://github.com/openbmc/phosphor-webui.git"
SRCREV = "4733a11b42fca6013e3957bf0e345d0cea086d96"

SRC_URI += "file://0001-Implement-KVM-in-webui.patch \
            file://0004-Implement-force-boot-to-bios-in-server-power-control.patch \
            file://0008-Pull-the-latest-novnc-package.patch \
            "

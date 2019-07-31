FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
EXTRA_OECONF += "--enable-fwupd_script"

SYSTEMD_SERVICE_${PN}-updater += "fwupd@.service"


SRC_URI += "file://0002-Redfish-firmware-activation.patch \
            file://0004-Changed-the-condition-of-software-version-service-wa.patch \
            file://0005-Modified-firmware-activation-to-launch-fwupd.sh-thro.patch \
            file://0006-Modify-the-ID-of-software-image-updater-object-on-DB.patch \
           "

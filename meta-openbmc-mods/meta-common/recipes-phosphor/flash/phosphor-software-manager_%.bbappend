FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
EXTRA_OECONF += "--enable-fwupd_script"

SYSTEMD_SERVICE_${PN}-updater += "fwupd@.service"

EXTRA_OECONF += "${@bb.utils.contains('IMAGE_FSTYPES', 'intel-pfr', '--enable-pfr_update', '', d)}"

SRC_URI += "file://0001-Add-more-error-types.patch \
            file://0002-Redfish-firmware-activation.patch \
            file://0004-Changed-the-condition-of-software-version-service-wa.patch \
            file://0005-Modified-firmware-activation-to-launch-fwupd.sh-thro.patch \
            file://0006-Modify-the-ID-of-software-image-updater-object-on-DB.patch \
            file://0007-Adding-StandBySpare-for-firmware-activation.patch \
            file://0008-item_updater-update-the-bmc_active-objectPath.patch \
            file://0009-Add-ApplyOptions-D-bus-property-under-Software.patch \
            file://0011-Fix-for-RedudancyPriority-in-item_updater.patch \
            file://0013-remove-image-file-on-pre-script-failures.patch \
           "

SRC_URI_PFR = "file://0007-PFR-images-support.patch \
               file://0008-PFR-image-HASH-verification.patch \
               file://0010-Add-error-reporting-to-pfr_image_manager.patch \
               file://0015-Fix-delete-image-by-ID-and-inhibit-removal-of-bmc_ac.patch \
              "

SRC_URI += "${@bb.utils.contains('IMAGE_FSTYPES', 'intel-pfr', SRC_URI_PFR, '', d)}"

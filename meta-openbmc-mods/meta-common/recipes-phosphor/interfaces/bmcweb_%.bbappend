SRC_URI = "git://github.com/openbmc/bmcweb.git"
SRCREV = "a90daf182891521fcc7c3e99ba266e6a55d4b4dd"

DEPENDS += "boost-url"
RDEPENDS_${PN} += "phosphor-nslcd-authority-cert-config"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

# add a user called bmcweb for the server to assume
# bmcweb is part of group shadow for non-root pam authentication
USERADD_PARAM_${PN} = "-r -s /usr/sbin/nologin -d /home/bmcweb -m -G shadow bmcweb"

GROUPADD_PARAM_${PN} = "web; redfish "

SRC_URI += "file://0001-Firmware-update-configuration-changes.patch \
            file://0002-Use-chip-id-based-UUID-for-Service-Root.patch \
            file://0004-bmcweb-handle-device-or-resource-busy-exception.patch \
            file://0005-EventService-https-client-support.patch \
            file://0006-Define-Redfish-interface-Registries-Bios.patch \
            file://0007-BIOS-config-Add-support-for-PATCH-operation.patch \
            file://0008-Add-support-to-ResetBios-action.patch \
            file://0009-Add-support-to-ChangePassword-action.patch \
            file://0010-managers-add-attributes-for-Manager.CommandShell.patch \
            file://0034-recommended-fixes-by-crypto-review-team.patch \
            file://0036-Fix-wrong-check-in-EventService-events.patch \
"


# Temporary downstream mirror of upstream patches, see telemetry\README for details
SRC_URI += "file://telemetry/0001-Redfish-TelemetryService-schema-implementation.patch \
            file://telemetry/0002-Add-POST-and-DELETE-in-MetricReportDefinitions.patch \
            file://telemetry/0003-Add-support-for-MetricDefinition-scheme.patch \
            file://telemetry/0004-Sync-Telmetry-service-with-EventService.patch \
"

# Temporary fix: Move it to service file
do_install_append() {
        install -d ${D}/var/lib/bmcweb
        install -d ${D}/etc/ssl/certs/authority
}

# Enable PFR support
EXTRA_OEMESON += "${@bb.utils.contains('IMAGE_FSTYPES', 'intel-pfr', '-Dredfish-provisioning-feature=enabled', '', d)}"

# Enable NBD proxy embedded in bmcweb
EXTRA_OEMESON += " -Dvm-nbdproxy=enabled"

# Disable dependency on external nbd-proxy application
EXTRA_OEMESON += " -Dvm-websocket=disabled"
RDEPENDS_${PN}_remove += "jsnbd"

# Enable Validation unsecure based on IMAGE_FEATURES
EXTRA_OEMESON += "${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'validation-unsecure', '-Dvalidate-unsecure-feature=enabled', '', d)}"


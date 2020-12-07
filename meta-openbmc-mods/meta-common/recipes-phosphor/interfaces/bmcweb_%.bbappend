SRC_URI = "git://github.com/openbmc/bmcweb.git"
SRCREV = "a8fe54f09be1deefc119d8dcf100da922496d46d"

DEPENDS += "boost-url"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

# add a user called bmcweb for the server to assume
# bmcweb is part of group shadow for non-root pam authentication
USERADD_PARAM_${PN} = "-r -s /usr/sbin/nologin -d /home/bmcweb -m -G shadow bmcweb"

GROUPADD_PARAM_${PN} = "web; redfish "

SRC_URI += "file://0001-Firmware-update-configuration-changes.patch \
            file://0002-Use-chip-id-based-UUID-for-Service-Root.patch \
            file://0004-bmcweb-handle-device-or-resource-busy-exception.patch \
            file://0005-EventService-https-client-support.patch \
"

# Temporary downstream mirror of upstream patches, see telemetry\README for details
SRC_URI += "file://telemetry/0001-Redfish-TelemetryService-schema-implementation.patch \
            file://telemetry/0002-Add-support-for-POST-in-MetricReportDefinitions.patch \
            file://telemetry/0003-Add-support-for-DELETE-in-MetricReportDefinitions-st.patch \
            file://telemetry/0004-Add-support-for-OnRequest-in-MetricReportDefinition.patch \
            file://telemetry/0005-Add-support-for-MetricDefinition-scheme.patch \
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


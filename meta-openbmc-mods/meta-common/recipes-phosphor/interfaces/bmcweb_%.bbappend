# todo(james) remove nobranch
SRC_URI = "git://github.com/openbmc/bmcweb.git"
SRCREV = "6964c9820ad101d6fc30badd1ae353efea3dd094"

DEPENDS += "boost-url"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

# add a user called bmcweb for the server to assume
# bmcweb is part of group shadow for non-root pam authentication
USERADD_PARAM_${PN} = "-r -s /usr/sbin/nologin -d /home/bmcweb -m -G shadow bmcweb"

GROUPADD_PARAM_${PN} = "web; redfish "

SRC_URI += "file://0001-Firmware-update-support-for-StandBySpare.patch \
            file://0002-Use-chip-id-based-UUID-for-Service-Root.patch \
            file://0003-bmcweb-changes-for-setting-ApplyOptions-ClearCfg.patch \
            file://0004-Remove-QueryString.patch \
            file://0004-bmcweb-handle-device-or-resource-busy-exception.patch \
            file://0005-EventService-https-client-support.patch \
            file://0005-VirtualMedia-fixes-for-Redfish-Service-Validator.patch \
            file://0006-Fix-Image-and-ImageName-values-in-schema.patch \
"

# Temporary downstream mirror of upstream patches, see telemetry\README for details
SRC_URI += "file://telemetry/0001-Redfish-TelemetryService-schema-implementation.patch \
            file://telemetry/0002-Add-support-for-POST-in-MetricReportDefinitions.patch \
            file://telemetry/0003-Add-support-for-DELETE-in-MetricReportDefinitions-st.patch \
            file://telemetry/0004-Add-support-for-OnRequest-in-MetricReportDefinition.patch \
            file://telemetry/0005-Add-support-for-MetricDefinition-scheme.patch \
            file://telemetry/0006-Fix-MetricReport-timestamp-for-EventService.patch \
"

# Temporary fix: Move it to service file
do_install_append() {
        install -d ${D}/var/lib/bmcweb
}

# Enable PFR support
EXTRA_OECMAKE += "${@bb.utils.contains('IMAGE_FSTYPES', 'intel-pfr', '-DBMCWEB_ENABLE_REDFISH_PROVISIONING_FEATURE=ON', '', d)}"

# Enable NBD proxy embedded in bmcweb
EXTRA_OECMAKE += " -DBMCWEB_ENABLE_VM_NBDPROXY=ON"

# Disable dependency on external nbd-proxy application
EXTRA_OECMAKE += " -DBMCWEB_ENABLE_VM_WEBSOCKET=OFF"
RDEPENDS_${PN}_remove += "jsnbd"

# Enable Validation unsecure based on IMAGE_FEATURES
EXTRA_OECMAKE += "${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'validation-unsecure', '-DBMCWEB_ENABLE_VALIDATION_UNSECURE_FEATURE=ON', '', d)}"


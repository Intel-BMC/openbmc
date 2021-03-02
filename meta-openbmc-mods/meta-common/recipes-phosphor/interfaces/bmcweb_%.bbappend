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
            file://0007-cpudimm-get-cpu-details-from-Redfish.patch \
            file://0008-systems-Fix-for-Processor-Summary-Model.patch \
            file://0009-Fix-MetricReportDefinitions-filter-not-working.patch \
            file://0010-Fix-EventService-stops-sending-events.patch \
            file://0011-Deallocate-memory-during-failed-case.patch \
            file://0012-System-Replace-chassis-name-in-Redfish.patch \
            file://0013-url_view-throws-if-a-parse-error-is-found.patch \
            file://0014-add-sufficient-delay-to-create-fw-update-object.patch \
            file://0015-Add-firmware-activation-messages-to-the-registry.patch \
            file://0016-EventService-Fix-type-mismatch-in-MetricReport.patch \
            file://0017-Add-MutualExclusiveProperties-registry.patch \
            file://0018-Add-sse-event-sequence-number.patch \
            file://0019-EventService-Limit-SSE-connections-as-per-design.patch \
            file://0020-EventService-Validate-SSE-query-filters.patch \
            file://0021-Define-PSU-redundancy-property.patch \
            file://0022-schema-add-missing-tags.patch \
            file://0023-OemComputerSystems-add-missing-odata.types.patch \
            file://0024-EventService-Log-events-for-subscription-actions.patch \
            file://0025-Add-missing-Context-property-to-MetricReport.patch \
            file://0026-http-status-code-for-subscriber-limit-exceed.patch \
            file://0009-Fix-memory-leak.patch \
            file://0027-EventService-Improvements-and-limitations.patch \
            file://0028-EventService-Schedule-MetricReport-data-format.patch \
            file://0029-Added-Validation-on-MessageId-and-RegistryPrefix.patch \
            file://0030-Initialize-Event-Service-Config-on-bmcweb-restart.patch \
            file://0031-get-on-crashdump-can-follow-redfish-privileges.patch \
            file://0032-fix-for-duplicate-redfish-event-log-ID-s.patch \
            file://0033-Redfish-validator-conformance-fix.patch \
            file://0034-Avoid-using-deleted-Connection-in-Response.patch \
            file://0035-EventService-Fix-hostname-resolve-issue.patch \
            file://0036-fix-bmcweb-crash-during-sol-communication.patch \
            file://0037-Use-non-throw-version-of-remote_endpoint.patch \
            file://0038-Change-Severity-for-ServiceFailure-redfish-event.patch \
            file://0039-Return-InternalError-on-DBus-error.patch \
            file://0040-Add-boundary-check-to-avoid-crash.patch \
            file://0041-Revamp-Redfish-Event-Log-Unique-ID-Generation.patch \
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


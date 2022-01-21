SRC_URI = "git://github.com/openbmc/bmcweb.git"
SRCREV = "b7ff344535c42af074c60bfb272ef66a2ba157b4"

DEPENDS += "boost-url"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

# add a user called bmcweb for the server to assume
# bmcweb is part of group shadow for non-root pam authentication
USERADD_PARAM:${PN} = "-r -s /usr/sbin/nologin -d /home/bmcweb -m -G shadow bmcweb"

GROUPADD_PARAM:${PN} = "web; redfish "

SRC_URI += "file://0001-Firmware-update-configuration-changes.patch \
            file://0002-Use-chip-id-based-UUID-for-Service-Root.patch \
            file://0010-managers-add-attributes-for-Manager.CommandShell.patch \
            file://0011-bmcweb-Add-PhysicalContext-to-Thermal-resources.patch \
            file://0012-Log-RedFish-event-for-Invalid-login-attempt.patch \
            file://0013-Add-UART-routing-logic-into-host-console-connection-.patch \
            file://0014-recommended-fixes-by-crypto-review-team.patch \
            file://0015-Add-state-sensor-messages-to-the-registry.patch \
            file://0016-Fix-bmcweb-crashes-if-socket-directory-not-present.patch \
            file://0017-Add-msg-registry-for-subscription-related-actions.patch \
            file://0018-bmcweb-Add-BMC-Time-update-log-to-the-registry.patch \
            file://0019-Add-generic-message-PropertySizeExceeded.patch \
            file://0020-Redfish-Deny-set-AccountLockDuration-to-zero.patch \
            file://0023-Add-get-IPMI-session-id-s-to-Redfish.patch \
            file://0024-Add-count-sensor-type.patch \
            file://0025-Add-Model-CoreCount-to-ProcessorSummary.patch \
            file://0026-Fix-Query-Parameters-issue.patch \
            file://0027-Workaround-Increase-timer-queue-size-and-reduce-time.patch \
"

# OOB Bios Config:
SRC_URI += "file://biosconfig/0001-Define-Redfish-interface-Registries-Bios.patch \
            file://biosconfig/0002-BaseBiosTable-Add-support-for-PATCH-operation.patch \
            file://biosconfig/0003-Add-support-to-ResetBios-action.patch \
            file://biosconfig/0004-Add-support-to-ChangePassword-action.patch \
            file://biosconfig/0005-Fix-remove-bios-user-pwd-change-option-via-Redfish.patch \
            file://biosconfig/0006-Add-fix-for-broken-feature-Pending-Attributes.patch \
"

# Virtual Media: Backend code is not upstreamed so downstream only patches.
SRC_URI += "file://vm/0001-Revert-Disable-nbd-proxy-from-the-build.patch \
            file://vm/0002-bmcweb-handle-device-or-resource-busy-exception.patch \
            file://vm/0003-Add-ConnectedVia-property-to-virtual-media-item-temp.patch \
            file://vm/0004-Invalid-status-code-from-InsertMedia-REST-methods.patch \
            file://vm/0005-Set-Inserted-redfish-property-for-not-inserted-resou.patch \
            file://vm/0006-Bmcweb-handle-permission-denied-exception.patch \
            file://vm/0007-Fix-unmounting-image-in-proxy-mode.patch \
"

# EventService: Temporary pulled to downstream. See eventservice\README for details
SRC_URI += "file://eventservice/0001-Add-unmerged-changes-for-http-retry-support.patch \
            file://eventservice/0002-EventService-https-client-support.patch \
            file://eventservice/0004-Add-Server-Sent-Events-support.patch \
            file://eventservice/0005-Add-SSE-style-subscription-support-to-eventservice.patch \
            file://eventservice/0006-Add-EventService-SSE-filter-support.patch \
            file://eventservice/0007-EventService-Log-events-for-subscription-actions.patch \
            file://eventservice/0008-Add-checks-on-Event-Subscription-input-parameters.patch \
            file://eventservice/0009-Restructure-Redifsh-EventLog-Transmit-code-flow.patch \
            file://eventservice/0010-Remove-Terminated-Event-Subscriptions.patch \
            file://eventservice/0011-Fix-bmcweb-crash-while-deleting-terminated-subscriptions.patch \
"

# Temporary downstream mirror of upstream patches, see telemetry\README for details
SRC_URI += " file://telemetry/0001-Add-support-for-MetricDefinition-scheme.patch \
             file://telemetry/0002-Sync-Telmetry-service-with-EventService.patch \
             file://telemetry/0003-Switched-bmcweb-to-use-new-telemetry-service-API.patch \
             file://telemetry/0004-Add-support-for-MetricDefinition-property-in-MetricReport.patch \
             file://telemetry/0005-Add-GET-method-for-TriggerCollection.patch \
             file://telemetry/0006-Revert-Remove-LogService-from-TelemetryService.patch \
             file://telemetry/0007-event-service-fix-added-Context-field-to-response.patch \
             file://telemetry/0009-Add-support-for-deleting-terminated-subscriptions.patch \
"

# Temporary downstream patch for routing and privilege changes
SRC_URI += " file://http_routing/0001-Add-asyncResp-support-during-handleUpgrade.patch \
             file://http_routing/0002-Move-privileges-to-separate-entity.patch \
             file://http_routing/0003-Add-Support-for-privilege-check-in-handleUpgrade.patch \
             file://http_routing/0004-Add-Privileges-to-Websockets.patch \
             file://http_routing/0005-Add-Privileges-to-SseSockets.patch \
"

# Temporary fix: Move it to service file
do_install:append() {
        install -d ${D}/var/lib/bmcweb
        install -d ${D}/etc/ssl/certs/authority
}

# Enable PFR support
EXTRA_OEMESON += "${@bb.utils.contains('IMAGE_FSTYPES', 'intel-pfr', '-Dredfish-provisioning-feature=enabled', '', d)}"

# Enable NBD proxy embedded in bmcweb
EXTRA_OEMESON += " -Dvm-nbdproxy=enabled"

# Disable dependency on external nbd-proxy application
EXTRA_OEMESON += " -Dvm-websocket=disabled"
RDEPENDS:${PN}:remove += "jsnbd"



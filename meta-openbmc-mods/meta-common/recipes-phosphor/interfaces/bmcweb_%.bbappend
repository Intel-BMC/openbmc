SRC_URI = "git://github.com/openbmc/bmcweb.git"
SRCREV = "85ffe86a60f50ce9ad5728caf384a0dd0c8cc6a5"

DEPENDS += "boost-url"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

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
            file://0025-Add-Model-to-ProcessorSummary.patch \
            file://0026-Revert-Delete-the-copy-constructor-on-the-Request.patch \
            file://0027-Convert-VariantType-to-DbusVariantType.patch \
            file://0028-Add-FirmwareResiliency-and-FirmwareUpdateStatus.patch \
            file://0029-Fix-Property-PhysicalContext-is-invalid-none.patch \
            file://0030-Change-Severity-for-ServiceFailure-redfish-event.patch \
            file://0031-Change-PcieType-to-PCIeType.patch \
            file://0032-Remove-chassis-from-the-odata-id-of-the-PSU.patch \
            file://0033-Add-message-registry-entry-for-Memhot-event.patch \
            file://0034-Update-odata.type-version-of-redfish-v1-AccountService.patch \
            file://0035-Add-MemoryMetrics-schema-file.patch \
            file://0036-PCIeFunctions-not-showing-in-Redfish.patch \
"

# OOB Bios Config:
SRC_URI += "file://biosconfig/0001-Define-Redfish-interface-Registries-Bios.patch \
            file://biosconfig/0002-BaseBiosTable-Add-support-for-PATCH-operation.patch \
            file://biosconfig/0003-Add-support-to-ResetBios-action.patch \
            file://biosconfig/0004-Add-support-to-ChangePassword-action.patch \
            file://biosconfig/0005-Fix-remove-bios-user-pwd-change-option-via-Redfish.patch \
            file://biosconfig/0006-Add-fix-for-broken-feature-Pending-Attributes.patch \
            file://biosconfig/0007-Add-BiosAttributeRegistry-node-under-Registries.patch \
            file://biosconfig/0008-Add-BIOSAttributesChanged-message-entry.patch \
"

# Virtual Media: Backend code is not upstreamed so downstream only patches.
SRC_URI += " \
            file://vm/0001-Revert-Disable-nbd-proxy-from-the-build.patch \
            file://vm/0002-bmcweb-handle-device-or-resource-busy-exception.patch \
            file://vm/0003-Add-ConnectedVia-property-to-virtual-media-item-temp.patch \
            file://vm/0004-Invalid-status-code-from-InsertMedia-REST-methods.patch \
            file://vm/0005-Set-Inserted-redfish-property-for-not-inserted-resou.patch \
            file://vm/0006-Bmcweb-handle-permission-denied-exception.patch \
            file://vm/0007-Fix-unmounting-image-in-proxy-mode.patch \
            file://vm/0008-Return-404-for-POST-on-Proxy-InsertMedia.patch \
            file://vm/0009-virtual_media-Fix-for-bmcweb-crash.patch \
"

# EventService: Temporary pulled to downstream. See eventservice\README for details
SRC_URI += "file://eventservice/0001-Add-unmerged-changes-for-http-retry-support.patch \
            file://eventservice/0002-EventService-https-client-support.patch \
            file://eventservice/0004-Add-Server-Sent-Events-support.patch \
            file://eventservice/0005-Add-SSE-style-subscription-support-to-eventservice.patch \
            file://eventservice/0006-Add-EventService-SSE-filter-support.patch \
            file://eventservice/0007-EventService-Log-events-for-subscription-actions.patch \
            file://eventservice/0008-Add-checks-on-Event-Subscription-input-parameters.patch \
            file://eventservice/0010-Remove-Terminated-Event-Subscriptions.patch \
            file://eventservice/0011-Fix-bmcweb-crash-while-deleting-terminated-subscriptions.patch \
            file://eventservice/0012-Add-support-for-deleting-terminated-subscriptions.patch \
            file://eventservice/0013-event-service-fix-added-Context-field-to-response.patch \
            file://eventservice/0014-Fix-Event-Subscription-URI.patch \
            file://eventservice/0015-Add-Configure-Self-support-for-Event-Subscriptions.patch \
"


# Temporary downstream mirror of upstream patches, see telemetry\README for details
SRC_URI += " file://telemetry/0001-Add-support-for-POST-on-TriggersCollection.patch \
             file://telemetry/0002-Revert-Remove-LogService-from-TelemetryService.patch \
             file://telemetry/0003-Switched-bmcweb-to-use-new-telemetry-service-API.patch \
             file://telemetry/0004-Fixed-timestamp-in-telemetry-service.patch \
"

# Temporary downstream patch for routing and privilege changes
SRC_URI += "file://http_routing/0001-Add-asyncResp-support-during-handleUpgrade.patch \
            file://http_routing/0002-Move-privileges-to-separate-entity.patch \
            file://http_routing/0003-Add-Support-for-privilege-check-in-handleUpgrade.patch \
            file://http_routing/0004-Add-Privileges-to-Websockets.patch \
            file://http_routing/0005-Add-Privileges-to-SseSockets.patch \
           "

# Enable PFR support
EXTRA_OEMESON += "${@bb.utils.contains('IMAGE_FSTYPES', 'intel-pfr', '-Dredfish-provisioning-feature=enabled', '', d)}"

# Enable NBD proxy embedded in bmcweb
EXTRA_OEMESON += " -Dvm-nbdproxy=enabled"

# Disable dependency on external nbd-proxy application
EXTRA_OEMESON += " -Dvm-websocket=disabled"
EXTRA_OEMESON += " -Dredfish-host-logger=disabled"
RDEPENDS:${PN}:remove += "jsnbd"



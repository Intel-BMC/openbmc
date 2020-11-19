FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0001-Only-allow-drive-sensors-on-bus-2-for-ast2500.patch \
            file://0002-Fix-missing-threshold-de-assert-event-when-threshold.patch \
            file://0003-Fix-PSU-PWM-fan-control.patch \
            file://0004-Check-readingStateGood-before-updating-thresholds-pr.patch \
            file://0005-ExitAir-Move-to-GetSensorConfiguration.patch \
            file://0006-Treat-negative-temperatures-as-errors.patch"

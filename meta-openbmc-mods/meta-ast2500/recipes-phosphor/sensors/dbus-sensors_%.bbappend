FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0001-Only-allow-drive-sensors-on-bus-2-for-ast2500.patch \
            file://0002-Fix-missing-threshold-de-assert-event-when-threshold.patch \
            file://0003-Fix-PSU-PWM-fan-control.patch \
            file://0004-Check-readingStateGood-before-updating-thresholds-pr.patch \
            file://0005-ExitAir-Move-to-GetSensorConfiguration.patch \
            file://0006-Treat-negative-temperatures-as-errors.patch \
            file://0007-Fix-ADC-threshold-hysteresis-to-one-percent-of-criti.patch \
            file://0008-Fix-sensor-lost-issue-on-TEMP-PSU-etc.patch \
            file://0009-NVMeSensor-use-available-interface-for-error-handlin.patch \
            file://0010-revert-revert-log-debug-information-for-sensor-thres.patch \
            file://0011-Check-readingStateGood-before-updating-thresholds-pr.patch \
            file://0012-PSUSensors-Move-to-GetSensorConfiguration.patch \
            file://0013-Fix-ExitAirTempSensor-calculation.patch \
            file://0014-Cancel-threshold-timer-in-adcsensor-destructor.patch \
            file://0015-IpmbSensor-Fix-SMBus-configuration-for-VR-Temp.patch \
            file://0016-Fix-threshold-assertion-events-for-cpu-adc-sensors.patch \
            file://0017-Add-more-boundary-checking-in-Texitair-calculation.patch \
            file://0018-ADCSensor-use-tmp-power-state-file-for-threshold.patch \
            "

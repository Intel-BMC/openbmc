#!/bin/sh

bitWiseAnd() {
    local IFS='&'
    printf "%s\n" "$(( $* ))"
}

ACBOOT="False"

while IFS=' ' read -ra OPTIONS; do
  for i in "${OPTIONS[@]}"; do
    while IFS='=' read option param; do
      if [ "resetreason" == "$option" ]; then
        if [ $(bitWiseAnd "$param" "0x1") -ne 0 ]; then
          ACBOOT="True"
        fi
      fi
    done <<< $i
  done
done < /proc/cmdline

busctl set-property xyz.openbmc_project.Settings /xyz/openbmc_project/control/host0/ac_boot xyz.openbmc_project.Common.ACBoot ACBoot s "$ACBOOT"

if [ "$ACBOOT" == "True" ]; then
  # On AC cycle, setting service's last event parameters of PFR reset to allow logging of every recovery event in redfish event log
  busctl set-property xyz.openbmc_project.Settings /xyz/openbmc_project/pfr/last_events  xyz.openbmc_project.PFR.LastEvents lastMajorErr y 0
  busctl set-property xyz.openbmc_project.Settings /xyz/openbmc_project/pfr/last_events  xyz.openbmc_project.PFR.LastEvents lastMinorErr y 0
  busctl set-property xyz.openbmc_project.Settings /xyz/openbmc_project/pfr/last_events  xyz.openbmc_project.PFR.LastEvents lastPanicCount y 0
  busctl set-property xyz.openbmc_project.Settings /xyz/openbmc_project/pfr/last_events  xyz.openbmc_project.PFR.LastEvents lastRecoveryCount y 0
fi

source /etc/os-release

echo "VERSION INFO - BMC - ${VERSION_ID}"

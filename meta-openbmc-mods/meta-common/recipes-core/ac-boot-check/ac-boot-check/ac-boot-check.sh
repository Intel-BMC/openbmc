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


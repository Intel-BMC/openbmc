#!/bin/bash

touch /etc/bc_fru_write_fails
sleep 190

if ! busctl tree xyz.openbmc_project.FruDevice | grep -q /xyz/openbmc_project/FruDevice/BRIGHTONCITY; then
       # Should not happen.
       echo “Fru Device not found”
       touch /etc/bc_fru_not_found
       exit 1
fi
maxRetries=3
while [ $maxRetries -gt 0 ]; do
  if busctl call xyz.openbmc_project.FruDevice "/xyz/openbmc_project/FruDevice" "xyz.openbmc_project.FruDeviceManager" WriteFru yyay 3 86 136 1 1 4 5 11 0 0 234 2 3 0 0 0 0 0 0 0 224 46 195 1 0 0 0 0 9 0 0 193 0 0 95 1 1 23 192 192 193 0 166 1 6 25 192 229 194 198 65 67 67 84 79 78 204 66 82 73 71 72 84 79 78 67 73 84 89 192 202 75 55 57 53 51 52 45 49 48 48 192 193 0 0 0 0 0 0 0 121 1 6 25 198 65 67 67 84 79 78 204 66 82 73 71 72 84 79 78 67 73 84 89 192 192 192 204 65 51 51 50 53 50 51 51 51 53 53 52 192 193 0 0 0 0 0 0 252; then
                 rm -rf /etc/bc_fru_write_fails
                 break;
       fi
       ((maxRetries--))
done
# Since FRU write is going through FruDevice service, intel-ipmi-oem replaceCacheFru() should refresh its cache after 30 seconds.
# Restart FruDevice service not required, ideally. Will do it if required

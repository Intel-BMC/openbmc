#!/bin/sh
busctl set-property  "xyz.openbmc_project.LED.GroupManager" \
"/xyz/openbmc_project/led/groups/enclosure_identify" \
"xyz.openbmc_project.Led.Group" "Asserted" b false

busctl set-property  "xyz.openbmc_project.LED.GroupManager" \
"/xyz/openbmc_project/led/groups/enclosure_identify_blink" \
"xyz.openbmc_project.Led.Group" "Asserted" b false

busctl set-property  "xyz.openbmc_project.LED.Controller.identify" \
"/xyz/openbmc_project/led/physical/identify" \
"xyz.openbmc_project.Led.Physical" "State" s "xyz.openbmc_project.Led.Physical.Action.Off"

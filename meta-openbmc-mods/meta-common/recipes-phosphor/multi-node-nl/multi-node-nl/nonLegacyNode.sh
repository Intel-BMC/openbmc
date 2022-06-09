#!/bin/bash

PWM_FILE="/sys/class/hwmon/hwmon0/pwm"
FAN_SPEED=$((255 * 80 / 100))

set_fan_speed() {
    local idx=0
    for ((idx=1; idx<=8; idx++))
    do
        if [ -f $PWM_FILE$idx ]; then
            echo $FAN_SPEED > $PWM_FILE$idx
        fi
    done
}

$(set_fan_speed)

#Stop power control service in NL mode
systemctl stop  xyz.openbmc_project.Chassis.Control.Power.service

export TERM=xterm
# Autologin root user to serial console (ttyS4) on boot
exec /sbin/agetty -a root -J -8 -L ttyS4 115200 $TERM

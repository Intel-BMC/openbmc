#!/bin/bash

# this script uses devmem to set hardware passthrough
# it is temporary and should be removed in the future

PASSTHROUGH_ENABLE=0x3000

if [[ -z $1 ]]; then
    echo "First Argument Must Be 1 To Enable or 0 To Disable"
    exit 1
fi

if [[ $1 != "0" && $1 != "1" ]]; then
    echo "Arg 1 must be 0 or 1"
    exit 1
fi

# read register
var=$(devmem 0x1e6e208C w)

# convert to int
typeset -i value=$( echo $(( $var )) )

if [[ $1 == "0" ]]; then
    value=$((value & ~PASSTHROUGH_ENABLE))
    # Mark the gpio reset out & power up pin as released
    echo "1" > /sys/class/gpio/gpio33/value
    echo "1" > /sys/class/gpio/gpio35/value
fi

if [[ $1 == "1" ]]; then
    value=$((value | PASSTHROUGH_ENABLE))
fi

val=$(printf '0x%x\n' $value)

#echo $val

devmem 0x1e6e208C w $val

# devmem 0x1e6e208C w

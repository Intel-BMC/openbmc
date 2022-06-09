#!/bin/bash

# this script checks the gpio id and loads the correct baseboard fru
FRUPATH="/etc/fru"
PRODIDPATH="/var/cache/private"
fruFile="$FRUPATH/baseboard.fru.bin"
prodIDFile="$PRODIDPATH/prodID"
source decodeBoardID.sh

read_id() {
    local idx=0
    local result=0
    local value=0
    for ((idx=0; idx<6; idx++))
    do
        typeset -i value=$(gpioget $(gpiofind "FM_BMC_BOARD_SKU_ID${idx}_N"))
        value=$((value << idx))
        result=$((result | value))
    done
    echo $result
}

if [ -f $fruFile -a -f $prodIDFile ] &&
    grep -q 'CPU part\s*: 0xc07' /proc/cpuinfo; then
    exit 0
fi

NAME="Unknown"
PRODID="0x00"
EEPROM_FRU=false

BOARD_ID=$(read_id)
decode_board_id

if [ ! -e $prodIDFile ]
then
    echo $PRODID >$prodIDFile
fi

if $EEPROM_FRU;
then
    # Remove baseboard filesystem FRU(if any), as this platform has EEPROM FRU.
    rm -f $fruFile
    exit 0
fi

if [ ! -f $fruFile ]
then
    cd /tmp
    mkdir -p $FRUPATH
    mkfru $NAME
    mv $NAME.fru.bin $fruFile
fi


#!/bin/bash

# this script checks the gpio id and loads the correct baseboard fru
FRUPATH="/etc/fru"
PRODIDPATH="/var/cache/private"
fruFile="$FRUPATH/baseboard.fru.bin"
prodIDFile="$PRODIDPATH/prodID"

if [ -f $fruFile -a -f $prodIDFile ]; then
    exit 0
fi

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

BOARD_ID=$(read_id)
if grep -q 'CPU part\s*: 0xb76' /proc/cpuinfo; then
    # AST2500
    case $BOARD_ID in
        12) NAME="D50TNP1SB"
            PRODID="0x99";;
        40) NAME="CooperCity"
            PRODID="0x9d";;
        42) NAME="WilsonCity"
            PRODID="0x91";;
        44) NAME="WilsonCityM"
            PRODID="0x91";;
        45) NAME="WilsonCity"
            PRODID="0x91";;
        60) NAME="M50CYP2SB2U"
            PRODID="0x98";;
        62) NAME="WilsonPoint"
            PRODID="0x9a";;
        *)  NAME="S2600WFT"
            PRODID="0x7b";;
    esac

elif grep -q 'CPU part\s*: 0xc07' /proc/cpuinfo; then
    # AST2600
    case $BOARD_ID in
        62) NAME="ArcherCity"
            PRODID="0x9c";;
        *)  NAME="AST2600EVB"
            PRODID="0x00";;
    esac

fi

if [ -z "$NAME" ]; then
    NAME="Unknown"
fi

if [ ! -e $prodIDFile ]
then
    echo $PRODID >$prodIDFile
fi

if [ ! -f $fruFile ]
then
    cd /tmp
    mkdir -p $FRUPATH
    mkfru $NAME
    mv $NAME.fru.bin $fruFile
fi



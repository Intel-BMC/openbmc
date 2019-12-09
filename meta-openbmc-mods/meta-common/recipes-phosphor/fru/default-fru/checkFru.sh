#!/bin/bash

# this script checks the gpio id and loads the correct baseboard fru
FRUPATH="/etc/fru"
fruFile="$FRUPATH/baseboard.fru.bin"
if [ -f $fruFile ]; then
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
    12) NAME="D50TNP1SB";;
    40) NAME="CooperCity";;
    42) NAME="WilsonCity";;
    45) NAME="WilsonCity";;
    60) NAME="M50CYP2SB2U";;
    62) NAME="WilsonPoint";;
    *)  NAME="S2600WFT";;
    esac

elif grep -q 'CPU part\s*: 0xc07' /proc/cpuinfo; then
    # AST2600
    case $BOARD_ID in
    62) NAME="ArcherCity";;
    *)  NAME="AST2600EVB";;
    esac

fi

if [ -z "$NAME" ]; then
    NAME="Unknown"
fi

cd /tmp
mkdir -p $FRUPATH
mkfru $NAME
mv $NAME.fru.bin $fruFile


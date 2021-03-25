#!/bin/bash

# this script uses the BOARD_ID set from checkFru.sh and provides the NAME,
# PRODID, and EEPROM_FRU values for this platform
decode_board_id() {
    if grep -q 'CPU part\s*: 0xb76' /proc/cpuinfo; then
        # AST2500
        if [ -f $fruFile -a -f $prodIDFile -a $BOARD_ID -ne 0 ]; then
            exit 0
        fi

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
            16) EEPROM_FRU=true
                PRODID="0xA1";;
             1) EEPROM_FRU=true
                PRODID="0xA5";;
             0) EEPROM_FRU=true
                PRODID="0xA0";;
        esac
    fi
}

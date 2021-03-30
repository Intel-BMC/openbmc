#!/bin/bash

# this script uses the BOARD_ID set from checkFru.sh and provides the NAME,
# PRODID, and EEPROM_FRU values for this platform
decode_board_id() {
    if grep -q 'CPU part\s*: 0xb76' /proc/cpuinfo; then
        # AST2500
        if [ -f $fruFile -a -f $prodIDFile -a $BOARD_ID -ne 0 ]; then
            exit 0
        fi
        NAME="S2600WFT"
        PRODID="0x7b"
    fi
}

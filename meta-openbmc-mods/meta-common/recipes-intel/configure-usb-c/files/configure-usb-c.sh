#!/bin/bash

I2C_BUS=7
CHIP_ADDR=0x47

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
if grep -q 'CPU part\s*: 0xc07' /proc/cpuinfo; then # AST2600
    if [[ $BOARD_ID == 62 || $BOARD_ID == 61 ]]; then
        # Write 0x01 data into General Control Register (offset 0x0A)
        # Write 0x21 data into General Control Register (offset 0x0A)
        # Write 0x80 data into Connection Status Register (offset 0x08)
        # Write 0x20 data into General Control Register (offset 0x0A)
        i2cset -y $I2C_BUS $CHIP_ADDR 0x0a 0x01; i2cset -y $I2C_BUS $CHIP_ADDR 0x0a 0x21; i2cset -y $I2C_BUS $CHIP_ADDR 0x08 0x80; i2cset -y $I2C_BUS $CHIP_ADDR 0x0a 0x20
        echo "Configured USB Type C controller"
    fi
fi

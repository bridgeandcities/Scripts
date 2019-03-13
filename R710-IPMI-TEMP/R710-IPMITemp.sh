#!/bin/bash

# ----------------------------------------------------------------------------------
# Script for checking the temperature reported by the ambient temperature sensor,
# and if deemed too high send the raw IPMI command to enable dynamic fan control.
#
# Requires:
# ipmitool – apt-get install ipmitool
# ----------------------------------------------------------------------------------

# TEMPERATURE
# Change this to the temperature in celcius you are comfortable with.
# If the temperature goes above the set degrees it will send raw IPMI command to enable dynamic fan control
MAXTEMP=39
TEMP_STEP1=28
TEMP_STEP2=30
TEMP_STEP3=32

# 28 -> 1%
# 30 -> 8%
# 32 -> 10%
# 33 -> Automatic control

# This variable sends a IPMI command to get the temperature, and outputs it as two digits.
# Do not edit unless you know what you do.
TEMP=$(ipmitool -I open sdr type temperature |grep Ambient |grep degrees |grep -Po '\d{2}' | tail -1)

if [ $TEMP -ge $MAXTEMP ]; then
        echo " $TEMP is > $MAXTEMP. Switching to automatic fan control "
        ipmitool -I open raw 0x30 0x30 0x01 0x01
elif [ $TEMP -le $TEMP_STEP1 ]; then
        echo " $TEMP is < $TEMP_STEP1. Switching to manual control @1200rpm "
        ipmitool -I open raw 0x30 0x30 0x01 0x00
        ipmitool -I open raw 0x30 0x30 0x02 0xff 0x01
elif [ $TEMP -le $TEMP_STEP2 ]; then
        echo " $TEMP is < $TEMP_STEP2. Switching to manual control @2000rpm "
        ipmitool -I open raw 0x30 0x30 0x01 0x00
        ipmitool -I open raw 0x30 0x30 0x02 0xff 0x08
elif [ $TEMP -le $TEMP_STEP3 ]; then
        echo " $TEMP is < $TEMP_STEP3. Switching to manual control @3000rpm "
        ipmitool -I open raw 0x30 0x30 0x01 0x00
        ipmitool -I open raw 0x30 0x30 0x02 0xff 0x10
fi


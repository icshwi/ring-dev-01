#!/usr/bin/bash

EXIST=1
NON_EXIST=0

declare -gr SC_SCRIPT="$(realpath "$0")"
declare -gr SC_TOP="${SC_SCRIPT%/*}"


function checkIfVar()
{
    #echo entered the function
    local var=$1
    local result=""
    if [ -z "$var" ]; then
	result=$NON_EXIST
	# doesn't exist
    else
	result=$EXIST
	# exist
    fi
    echo "result = ${result}"
}


USB_BUS_NUM="$(readlink /dev/serial/by-id/usb-Silicon_Labs_CP2104_USB_to_UART_Bridge_Controller_* | awk '{print substr($0,7,7)}' )"

USB_BUS_NUMA="$(echo ${USB_BUS_NUM} | awk '{print substr($0,0,7)}')"
USB_BUS_NUMB="$(echo ${USB_BUS_NUM} | awk '{print substr($0,9,7)}')"



echo ${USB_BUS_NUMA}
echo ${USB_BUS_NUMB}

if [[$(checkIfVar "${USB_BUS_NUMA}") -eq "$EXIST"]];
then
    echo "epicsEnvSet(USB_BUS_NUMA, \"${USB_BUS_NUMA}\")" > ${SC_TOP}/usb_bus_id
    if [[$(checkIfVar "${USB_BUS_NUMB}") -eq "$EXIST"]];
    then
        echo "epicsEnvSet(USB_BUS_NUMB, \"${USB_BUS_NUMB}\")" >> ${SC_TOP}/usb_bus_id
    fi	
else 
    printf "We cannot find a detector readout master in the system\n";
    exit;
fi

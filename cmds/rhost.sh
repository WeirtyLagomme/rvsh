#!/bin/bash

function rhost () {
    local vm_path="./vms/$SESSION_VM.vm"
    local connected_vms=$(getVar "$vm_path" "connected_vms")
    local header="\n Linked machines"
    echo -e "$header"
    local line=" "
    for (( i=0; i<15; i++ )); do line+="-"; done
    echo "$line"
    echo "$connected_vms" | sed 'y/\(\)/  /'
}

function helpRhost () {
    echo "Returns a list of all the virtual machines linked to the one you're currently connected to.
    
    > No arguments needed."
}

function needRhost () {
    echo "vmco"
}
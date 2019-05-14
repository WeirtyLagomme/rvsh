#!/bin/bash

# Returns all users connected to the vm
# $1 : vm name
function who () {
    local vm_name="$1"
    [[ -z $vm_name ]] && vm_name="$SESSION_VM"
    local vm_path="./vms/$vm_name.vm"
    local connected_users=$(getVar "$vm_path" "connected_users")
    local header="\n User\t\tConnected since\t\t\t\tID"
    echo -e "$header"
    local line=" "
    for (( i=0; i<74; i++ )); do line+="-"; done
    echo "$line"
    echo -e "${connected_users//,/\\t\\t}" | sed 'y/\(\)/ \n/'
}

function helpWho () {
    echo "[VMCO-ONLY]Returns a list of all users connected to the same virtual machine as you, along with their time and date of connection.
    
    > No arguments needed."
}
#!/bin/bash

# Returns all users connected to the vm
# $1 : vm name
function who () {
    local vm_name="$1"
    local vm_path="./vms/$vm_name.vm"
    local connected_users=$(getVar "$vm_path" "connected_users")
    local header="\n User\tConnected since\t\t\tID"
    echo -e "$header"
    local line=" "
    for (( i=0; i<58; i++ )); do line+="-"; done
    echo "$line"
    echo "$connected_users" | sed 'y/,\(\)/\t  /'
}
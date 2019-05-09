#!/bin/bash

# $1 : vm_name
function connect () {
    # VM name can't be empty
    local vm_name="$1"
    if [[ -z $vm_name ]]; then
        dispError "3" "VM name is required to connect"
        return 1
    fi
    # Incorrect VM name
    local vm="./vms/$vm_name.vm"
    if [[ ! -e $vm ]]; then
        dispError "3" "Incorrect VM name : \"$vm_name\" doesn't exists"
        return 1
    fi
    # VM must be linked
    local connected_vms=$(getVar "$vm" "connected_vms")
    if [[ $connected_vms != *"($SESSION_VM)"* ]]; then
        dispError "3" "Your current virtual machine \"$SESSION_VM\" isn't linked to \"$vm_name\""
        return 1
    fi
    # User must be authorized on VM
    local authorized_users=$(getVar "$vm" "authorized_users")
    if [[ $authorized_users != *"($SESSION_USER)"* ]]; then
        dispError "4" "You're not authorized to connect to \"$vm_name\""
        return 1
    fi
    # Switch VM
    sed -e s/"($SESSION_USER,$SESSION_START,$SESSION_ID)"//g -i "./vms/$SESSION_VM.vm"
    SESSION_VM="$vm_name"
    setVar "connected_users" "($SESSION_USER"','"$SESSION_START"','"$SESSION_ID)" "./vms/$SESSION_VM.vm" "push"
    dispNotif "0" "You're now connected to the \"$SESSION_VM\" virtual machine"
}

function helpConnect () {
    echo "
    Connect to another virtual machine linked to the one you're currently connected to.
    > connect vm_name"
}
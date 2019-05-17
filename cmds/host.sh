#!/bin/bash

# $1 : vm_name
function addHost () {
    local vm_name="$1"
    # VM name must be available
    if [[ -e "./vms/$vm_name.vm" ]]; then
        dispError "3" "The vm name \"$vm_name\" isn't available"
        return 1
    fi
    # VM name min length is 3
    if (( ${#vm_name} < 3 )); then
        dispError "3" "VM name must have a min length of 3"
        return 1
    fi
    # Validate vm_name format
    if [[ ! $vm_name =~ ^[A-Za-z0-9_]*$ ]]; then
        dispError "3" "VM name can only contain the following caracters : [A-Za-z0-9_]"
        return 1
    fi
    # Create VM file
    echo $(cat ./config/default.vm) >> "./vms/$vm_name.vm"
    dispNotif "0" "The \"$vm_name\" virtual machine has been successfuly created"
}

# $1 : vm_name
function removeHost () {
    # Incorrect VM name
    local vm_name="$1"
    local vm="./vms/$vm_name.vm"
    if [[ ! -e $vm ]]; then
        dispError "3" "Incorrect VM name : \"$vm_name\" doesn't exists"
        return 1
    fi
    # Delete VM file
    rm "$vm"
    dispNotif "0" "The \"$vm_name\" virtual machine has been successfuly deleted"
}

# $1 : vm_name
# $2 : second vm_name
function linkHost () {
    local vm_name="$1"
    # Second vm name can't be empty
    local sec_vm_name="$2"
    if [[ -z $sec_vm_name ]]; then
        dispError "3" "The second vm_name argument must be specified"
        return 1
    fi
    # Incorrect VM names
    local vm_names=("$vm_name" "$sec_vm_name")
    for vmn in "${vm_names[@]}"; do
        local vm="./vms/$vmn.vm"
        if [[ ! -e $vm ]]; then
            dispError "3" "Incorrect VM name : \"$vmn\" doesn't exists"
            return 1
        fi
    done
    # Already linked
    local connected_vms=$(getVar "./vms/$vm_name.vm" "connected_vms")
    if [[ $connected_vms == *"($sec_vm_name)"* ]]; then
        dispError "3" "\"$vm_name\" and \"$sec_vm_name\" are already linked"
        return 1
    fi
    # Create link
    setVar "connected_vms" "./vms/$vm_name.vm" "push" "($sec_vm_name)"
    setVar "connected_vms" "./vms/$sec_vm_name.vm" "push" "($vm_name)"
    dispNotif "0" "\"$vm_name\" and \"$sec_vm_name\" have been successfuly linked"
}

# $1 : vm_name
# $2 : second vm_name
function unlinkHost () {
    local vm_name="$1"
    # Second vm name can't be empty
    local sec_vm_name="$2"
    if [[ -z $sec_vm_name ]]; then
        dispError "3" "The second vm_name argument must be specified"
        return 1
    fi
    # Incorrect VM names
    local vm_names=("$vm_name" "$sec_vm_name")
    for vmn in "${vm_names[@]}"; do
        local vm="./vms/$vmn.vm"
        if [[ ! -e $vm ]]; then
            dispError "3" "Incorrect VM name : \"$vmn\" doesn't exists"
            return 1
        fi
    done
    # Already linked
    local connected_vms=$(getVar "./vms/$vm_name.vm" "connected_vms")
    if [[ $connected_vms != *"($sec_vm_name)"* ]]; then
        dispError "3" "\"$vm_name\" and \"$sec_vm_name\" are not linked"
        return 1
    fi
    # Delete link
    setVar "connected_vms" "./vms/$vm_name.vm" "pop" "($sec_vm_name)"
    setVar "connected_vms" "./vms/$sec_vm_name.vm" "pop" "($vm_name)"
    dispNotif "0" "\"vm_name\" and \"$sec_vm_name\" have been successfuly unlinked"
}

function helpHost () { # TODO : must be able to (un)link more than 2 at the time
    echo "Allows you to add or remove virtual machines from the network, and manage their links.
    
    #> admin
    > host -add vm_name
    > host -remove vm_name
    > host -link vm_name_1 vm_name_2
    > host -unlink vm_name_1 vm_name_2"
}
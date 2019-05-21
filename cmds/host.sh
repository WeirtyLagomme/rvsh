#!/bin/bash

# $1 : vm_name
function addHost () {
    local vm_name="$1"
    # Create VM file
    echo $(cat ./config/default.vm) >> "./vms/$vm_name.vm"
    dispNotif "0" "The ${OR}$vm_name${NC} virtual machine has been successfuly created"
}

# $1 : vm_name
function removeHost () {
    local vm_name="$1"
    # Delete VM file
    rm "./vms/$vm_name.vm"
    dispNotif "0" "The ${OR}$vm_name${NC} virtual machine has been successfuly deleted"
}

# $1 : vm_name
# $2 : second vm_name
function linkHost () {
    local vm_name="$1"
    local sec_vm_name="$2"
    # Incorrect VM names
    local vm_names=("$vm_name" "$sec_vm_name")
    for vmn in "${vm_names[@]}"; do
        local vm="./vms/$vmn.vm"
        if [[ ! -e $vm ]]; then
            dispError "3" "Incorrect VM name : ${OR}$vmn${NC} doesn't exists"
            return 1
        fi
    done
    # Already linked
    local connected_vms=$(getVar "./vms/$vm_name.vm" "connected_vms")
    if [[ $connected_vms == *"($sec_vm_name)"* ]]; then
        dispError "3" "${OR}$vm_name${NC} and ${OR}$sec_vm_name${NC} are already linked"
        return 1
    fi
    # Create link
    setVar "connected_vms" "./vms/$vm_name.vm" "push" "($sec_vm_name)"
    setVar "connected_vms" "./vms/$sec_vm_name.vm" "push" "($vm_name)"
    dispNotif "0" "${OR}$vm_name${NC} and ${OR}$sec_vm_name${NC} have been successfuly linked"
}

# $1 : vm_name
# $2 : second vm_name
function unlinkHost () {
    local vm_name="$1"
    local sec_vm_name="$2"
    # Incorrect VM names
    local vm_names=("$vm_name" "$sec_vm_name")
    for vmn in "${vm_names[@]}"; do
        local vm="./vms/$vmn.vm"
        if [[ ! -e $vm ]]; then
            dispError "3" "Incorrect VM name : ${OR}$vmn${NC} doesn't exists"
            return 1
        fi
    done
    # Already linked
    local connected_vms=$(getVar "./vms/$vm_name.vm" "connected_vms")
    if [[ $connected_vms != *"($sec_vm_name)"* ]]; then
        dispError "3" "${OR}$vm_name${NC} and ${OR}$sec_vm_name${NC} are not linked"
        return 1
    fi
    # Delete link
    setVar "connected_vms" "./vms/$vm_name.vm" "pop" "($sec_vm_name)"
    setVar "connected_vms" "./vms/$sec_vm_name.vm" "pop" "($vm_name)"
    dispNotif "0" "The virtual machines ${OR}$vm_name${NC} and ${OR}$sec_vm_name${NC} have been successfuly unlinked"
}

function helpHost () { # TODO : must be able to (un)link more than 2 at the time
    echo "Allows you to add or remove virtual machines from the network, and manage their links.
    
    #> admin
    > host -add vm_name{file:!vm,format:name,min:3}
    > host -remove vm_name{file:vm}
    > host -link vm_name_1{file:vm} vm_name_2{file:vm}
    > host -unlink vm_name_1{file:vm} vm_name_2{file:vm}"
}
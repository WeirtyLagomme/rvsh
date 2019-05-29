#!/bin/bash

# $1 : vm_name
function addHost () {
    local vm_name="$1"
    # Create vm directory
    mkdir "./vms/$vm_name" && cp -R "./config/defaults/vm/." $_
    dispNotif "0" "The ${OR}$vm_name${NC} virtual machine has been successfuly created"
}

# $1 : vm_name
function removeHost () {
    local vm_name="$1"
    # Remove vm from user's auth
    while read username; do
        sed -i '/^'"$vm_name"'$/d' "./usrs/$username/auths"
    done < "./vms/$vm_name/auths"
    # Delete VM file
    rm -rf "./vms/$vm_name"
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
        entityExists "true" "vm" "$vmn" "3" || return 1
    done
    # Already linked
    if isInFile "./vms/$vm_name/links" "$sec_vm_name"; then
        dispError "3" "${OR}$vm_name${NC} and ${OR}$sec_vm_name${NC} are already linked"
        return 1
    fi
    # Create link
    fileStream "append" "./vms/$vm_name/links" "$sec_vm_name"
    fileStream "append" "./vms/$sec_vm_name/links" "$vm_name"
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
        entityExists "true" "vm" "$vmn" "3" || return 1
    done
    # Already unlinked
    if ! isInFile "./vms/$vm_name/links" "$sec_vm_name"; then 
        dispError "3" "${OR}$vm_name${NC} and ${OR}$sec_vm_name${NC} are not linked"
        return 1
    fi
    # Delete link
    fileStream "remove" "./vms/$vm_name/links" "$sec_vm_name"
    fileStream "remove" "./vms/$sec_vm_name/links" "$vm_name"
    dispNotif "0" "The virtual machines ${OR}$vm_name${NC} and ${OR}$sec_vm_name${NC} have been successfuly unlinked"
}

function helpHost () { # TODO : must be able to (un)link more than 2 at the time
    echo "Allows you to add or remove virtual machines from the network, and manage their links.
    
    #> admin
    > host -add vm_name{file:!vm,format:norm,min:3}
    > host -remove vm_name{file:vm}
    > host -link vm_name_1{file:vm} vm_name_2{file:vm}
    > host -unlink vm_name_1{file:vm} vm_name_2{file:vm}"
}
#!/bin/bash

# Connect mode startup
# $1 : vm_name
# $2 : username
function connectMode () {
    local vm_name=$1
    local username=$2
    validateVM $vm_name
    validateUser $vm_name $username
    connectVM $vm_name $username
}


# Check VM name validity
# $1 : vm_name
function validateVM () {
    # VM name can't be empty
    local vm_name=$1
    if [ "$vm_name" = "" ]; then
        dispError "1" "VM name is required to connect"
        exit 128 # Invalid arg
    fi
    # Incorrect VM name
    local vm=./vms/$vm_name.vm
    if [ ! -f $vm ]; then
        dispError "1" "Incorrect VM name"
        exit 128 # Invalid arg
    fi
}

# Check user validity
# $1 : vm_name
# $2 : username
function validateUser () {
    # VM name can't be empty
    local username=$2
    if [ "$username" = "" ]; then
        dispError "1" "Username is required to connect"
        exit 128 # Invalid arg
    fi
    # User must be authorized on VM
    local vm_name=$1
    local vm=./vms/$vm_name.vm
    local authorized_users=$(getVar "$vm" "authorized_users")
    if [[ "$authorized_users" != *"$username"* ]]; then
        dispError "1" "You're not authorized to connect to \"$vm_name\""
        exit 128 # Invalid arg
    fi
}

# Connect to VM
# $1 : vm_name
# $2 : username
function connectVM () {
    local vm_name=$1
    local username=$2
    echo -ne "${CY}$username${NC}@${GR}$vm_name${NC}>"
}
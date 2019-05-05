#!/bin/bash

# $1 : action mode
# $2 : vm_name
function host () {
    # Admin mode only
    if [[ $SESSION_MODE != "admin" ]]; then
        dispError "4" "You must be in admin mode in order to use this command"
        return 1
    fi
    # Action mode can't be empty
    local action=$1
    if [[ -z $action ]]; then
        dispError "3" "The action_mode argument must be specified"
        return 1
    fi
    # VM name can't be empty
    local vm_name=$2
    if [[ -z $vm_name ]]; then
        dispError "3" "The vm_name argument must be specified"
        return 1
    fi
    # Select mode
    case $action in
        -a | -add )
            addHost "$vm_name"
            ;;
        -r | -remove )
            removeHost "$vm_name"
            ;;
        * )
            dispError "3" "Wrong argument : \"$action\" isn't a valid action_mode"
            return 1
    esac
}

# $1 : vm_name
function addHost () {
    local vm_name="$1"
    # Validate vm_name format
    if [[ ! $vm_name =~ ^[A-Za-z0-9_]*$ ]]; then
        dispError "3" "VM name can only contain the following caracters : [A-Za-z0-9_]"
        return 1
    fi
    # Create VM file
    touch "./vms/$1.vm"
    dispNotif "0" "The \"$vm_name\" virtual machine has been successfuly created"
}

# $1 : vm_name
function removeHost () {
    # Incorrect VM name
    local vm_name="$1"
    local vm=./vms/$vm_name.vm
    if [[ ! -e $vm ]]; then
        dispError "3" "Incorrect VM name : \"$vm_name\" doesn't exists"
        return 1
    fi
    # Delete VM file
    rm "$vm"
    dispNotif "0" "The \"$vm_name\" virtual machine has been successfuly deleted"
}
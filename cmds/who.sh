#!/bin/bash

function who () {
    # Must be connected to VM
    if [[ -z $SESSION_VM ]]; then
        dispError "2" "You must be connected to a VM in order to user this command"
        return 1
    fi
    # Show connected users
    local vm_path="./vms/$SESSION_VM.vm"
    local connected_users=$(getVar "$vm_path" "connected_users")
    echo ""
    echo "$connected_users" | sed 'y/,\(\)/\t \n/' 
}
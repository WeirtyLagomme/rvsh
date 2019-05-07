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
    local header="\n User\tConnected since\t\t\tID"
    echo -e "$header"
    local line=" "
    for (( i=0; i<58; i++ )); do line+="-"; done
    echo "$line"
    echo "$connected_users" | sed 'y/,\(\)/\t  /'
}
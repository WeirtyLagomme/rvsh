#!/bin/bash

# $1 : vm_name
function connect () {
    local vm_name="$1"
    # Same VM name as current
    [[ $vm_name == $SESSION_VM ]] && dispError "3" "You're already connected to ${OR}$vm_name${NC}" && return 1
    # VM must be linked
    if ! isInFile "./vms/$SESSION_VM/links" "$vm_name"; then
        dispError "3" "Your current virtual machine \"$SESSION_VM\" isn't linked to ${OR}$vm_name${NC}"
        return 1
    fi
    # User must be authorized on VM
    if ! isInFile "./vms/$vm_name/auths" "$SESSION_USER"; then 
        dispError "4" "You're not authorized to connect to ${OR}$vm_name${NC}"
        return 1
    fi
    # Switch VM
    fileStream "remove" "./vms/$SESSION_VM/sessions" "$SESSION_USER,$SESSION_START,$SESSION_ID"
    SESSION_VM="$vm_name"
    fileStream "append" "./vms/$SESSION_VM/sessions" "$SESSION_USER,$SESSION_START,$SESSION_ID"
    dispNotif "0" "You're now connected to the ${OR}$SESSION_VM${NC} virtual machine"
}

function helpConnect () {
    echo "Connect to another virtual machine linked to the one you're currently connected to.

    #> connect
    > connect vm_name{file:vm}"
}
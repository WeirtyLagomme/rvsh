#!/bin/bash

# $1 : username@vm_name
# $2 : message
function write () {
    # Validate target format
    if [[ ! $target =~ ^[A-Za-z0-9_]*@[A-Za-z0-9_]*$ ]]; then
        dispError "3" "Incorrect message target format, needed username@vm_name" && return 1
    fi
    # User must exists
    local username=$(cut -d@ -f1 <<< "$target")
    fileExists "$username" "usr" "3" "true" || return 1
    # VM must exists
    local vm_name=$(cut -d@ -f2 <<< "$target")
    fileExists "$vm_name" "vm" "3" "true" || return 1
    # User must be connected on VM
    if ! isInFile "./vms/$vm_name/sessions" "$username"; then
        dispError "3" "${OR}$username${NC} isn't connected to the ${OR}$vm_name${NC} virtual machine" && return 1
    fi
    # Send message
    echo "$(date) $SESSION_USER $message" >> "./usrs/$username/msgs/unread"
}

function helpWrite () {
    echo "Send a message to any other user
    
    > write username@vm_name message"
}
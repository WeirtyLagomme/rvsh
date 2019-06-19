#!/bin/bash

# $1 : username@vm_name
# $2 : message
function write () {
    # Set locals
    local target="$1"
    local message="$2"
    # Validate target format
    if [[ ! $target =~ ^[A-Za-z0-9_]*@[A-Za-z0-9_]*$ ]]; then
        dispError "3" "Incorrect message target format, needed username@vm_name" && return 1
    fi
    # User must exists
    local username=$(cut -d@ -f1 <<< "$target")
    entityExists "true" "usr" "$username" "3" || return 1
    # VM must exists
    local vm_name=$(cut -d@ -f2 <<< "$target")
    entityExists "true" "vm" "$vm_name" "3" || return 1
    # User must be connected on VM
    if [[ -z $(grep ^"$username" "./vms/$vm_name/sessions") ]]; then
        dispError "3" "${OR}$username${NC} isn't connected to the ${OR}$vm_name${NC} virtual machine" && return 1
    fi
    # Send message
    echo "$(date '+%d-%m-%Y %H:%M:%S') $SESSION_USER $message" >> "./usrs/$username/msgs/unread"
}

function helpWrite () {
    echo "Send a message to any other user
    
    > write username@vm_name message"
}
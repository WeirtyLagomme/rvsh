#!/bin/bash

# $1 : username@vm_name
# $2 : message
function write () {
    # Validate target format
    if [[ ! $target =~ ^[A-Za-z0-9_]*@[A-Za-z0-9_]*$ ]]; then
        dispError "3" "Incorrect message target format, needed username@vm_name"
        return 1
    fi
    # User must exists
    local username=$(echo "$target" | cut -d@ -f1)
    if [[ ! -e "./usrs/$username.usr" ]]; then
        dispError "3" "Incorrect username : \"$username\" doesn't exists"
        return 1
    fi
    # VM must exists
    local vm_name=$(echo "$target" | cut -d@ -f2)
    if [[ ! -e "./vms/$vm_name.vm" ]]; then
        dispError "3" "Incorrect vm_name : \"$vm_name\" doesn't exists"
        return 1
    fi
    # User must be connected on VM
    local connected_users=$(getVar "./vms/$vm_name.vm" "connected_users")
    if [[ $connected_users != *($username,*,*)* ]]; then
        dispError "3" "\"$username\" isn't connected to the \"$vm_name\" virtual machine"
        return 1
    fi
    # Send message
    setVar "unread_msgs" "./usrs/$username.usr" "push" "($SESSION_USER,$msg)"
}

function helpWrite () {
    echo "Send a message to any other user
    
    > write username@vm_name message"
}
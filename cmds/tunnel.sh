#!/bin/bash

# $1 : vm_name
function tunnel () {
    # Set locals
    local vm="$1"
    # Path must exists
    ! path "$SESSION_VM" "$vm" && return 1
    connectSu "$vm" "$SESSION_USER"
}

function helpTunnel () {
    printf "If path exists, uses the shortest one to connect from your current virtual machine to another one.
    
    #> connect
    > tunnel vm_name{file:vm}"
}
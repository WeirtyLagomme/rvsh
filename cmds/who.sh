#!/bin/bash

function who () {
    local vm_path="./vms/$SESSION_VM.vm"
    local connected_users=$(getVar "$vm_path" "connected_users")
    echo ""
    echo "$connected_users" | sed 'y/,\(\)/\t \n/' 
}
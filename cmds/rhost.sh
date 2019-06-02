#!/bin/bash

function rhost () {
    local connected_vms=$(command cat "./vms/$SESSION_VM/links")
    local header="\n Linked virtual machines"
    echo -e "$header"
    local line=" "
    for (( i=0; i<22; i++ )); do line+="-"; done
    echo "$line"
    echo "$connected_vms" | sed 'y/\(\)/  /'
}

function helpRhost () {
    echo "Returns a list of all the virtual machines linked to the one you're currently connected to.
    
    #> connect"
}
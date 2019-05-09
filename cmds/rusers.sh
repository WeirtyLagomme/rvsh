#!/bin/bash

function rusers () {
    for vm in ./vms/*.vm; do
        local vm_name=$(basename $vm | cut -d. -f1)
        echo -e "\n [${CY}$vm_name${NC}]"
        who "$vm_name"
    done
}

function helpRusers () {
    echo "
    Returns a list of all the users connected on the virtual network, along with the virtual machine they are connected to and their connection time and date.
    > No arguments needed."
}
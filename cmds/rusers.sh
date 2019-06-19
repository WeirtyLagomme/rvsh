#!/bin/bash

function rusers () {
    command ls ./vms/*/ &>/dev/null || dispNotif "0" "No existing virtual machines" && return 1
    for vm in "./vms/*/"; do
        local vm_name=$(basename $vm)
        echo -e "\n [${BL}$vm_name${NC}]"
        who "$vm_name"
    done
}

function helpRusers () {
    echo "Returns a list of all the users connected on the virtual network, along with the virtual machine they are connected to and their connection time and date."
}
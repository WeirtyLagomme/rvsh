#!/bin/bash

function rusers () {
    for vm in ./vms/*.vm; do
        local vm_name=$(basename $vm | cut -d. -f1)
        echo -e "\n[${CY}$vm_name${NC}]"
        who
    done
}
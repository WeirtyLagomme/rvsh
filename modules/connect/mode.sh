#!/bin/bash

# Startup connect mode
function connectMode () {
    sed -i 's/connected_users="/&\('"$SESSION_USER"','"$SESSION_START"','"$SESSION_ID"'\)/' ./vms/flash.vm
    echo -ne "\n${CY}$SESSION_USER${NC}@${GR}$SESSION_VM${NC}>"
    # Wait for command
    local cmd
    local state="waiting"
    while [[ true ]]; do
        read cmd
        case $cmd in
            'who' )
                who
                ;;
            * )
                dispError "2" "Incorrect command : \"$cmd\" doesn't exists"
                ;;
        esac
        echo -ne "\n${CY}$SESSION_USER${NC}@${GR}$SESSION_VM${NC}>"
    done
}

function who () {
    local vm_path="./vms/$SESSION_VM.vm"
    local connected_users=$(getVar "$vm_path" "connected_users")
    echo ""
    echo "$connected_users" | sed 'y/,\(\)/\t \n/' 
}
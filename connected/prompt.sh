#!/bin/bash

function startPrompt () {
    # Display prompt
    local prompt
    if [[ $SESSION_MODE == "connect" ]]; then
        sed -i 's/connected_users="/&\('"$SESSION_USER"','"$SESSION_START"','"$SESSION_ID"'\)/' ./vms/flash.vm
        prompt="\n${CY}$SESSION_USER${NC}@${GR}$SESSION_VM${NC}>"
    elif [[ $SESSION_MODE == "admin" ]]; then
        prompt="\n${CY}$SESSION_USER${NC}@${GR}rvsh${NC}>"
    fi
    echo -ne "$prompt"
    executeCommand "$prompt"
}

# $1 : prompt
function executeCommand () {
    # Wait for command
    local cmd
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
        echo -ne "$prompt"
    done
}
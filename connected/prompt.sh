#!/bin/bash

function startPrompt () {
    # Display prompt
    local prompt
    if [[ $SESSION_MODE == "connect" ]]; then
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
            'who' ) who ;;
            * )
                error_msg="Incorrect command : \"$cmd\" doesn't exists"
                [[ -z $cmd ]] && error_msg="Missing command : no command provided"
                dispError "2" "$error_msg"
                ;;
        esac
        echo -ne "$prompt"
    done
}
#!/bin/bash

function startPrompt () {
    # Display prompt
    local host
    [[ $SESSION_MODE == "connect" ]] && host="$SESSION_VM"
    [[ $SESSION_MODE == "admin" ]] && host="rvsh"
    local prompt="\n${CY}$SESSION_USER${NC}@${GR}$host${NC}>"
    executeCommand
}

function executeCommand () {
    # Wait for command & args
    while IFS= read -e -p "$(echo -e "$prompt") " cmd; do
        # Save command to history
        [[ ! -z $cmd ]] && history -s "$cmd"
        # Split command in args
        local args=()
        IFS=' ' read -r -a args <<< "$cmd"
        # Match command
        case "${args[0]}" in
            who ) 
                who 
                ;;
            host ) # TODO : A TERMINER (les liens entre vms)
                host "${args[1]}" "${args[2]}"
                ;;
            passwd )
                passwd "${args[1]}" "${args[2]}" "${args[3]}"
                ;;
            rusers )
                rusers
                ;;
            * )
                [[ ! -z $cmd ]] && dispError "2" "Incorrect command : \"${args[0]}\" doesn't exists"
                ;;
        esac
    done
}
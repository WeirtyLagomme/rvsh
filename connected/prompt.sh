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
        local err_vm_co="You must be connected to a VM in order to use this command"
        local err_admin="You must be in admin mode in order to use this command"
        case "${args[0]}" in
            help )
                helpCmd "${args[1]}"
                ;;
            clear )
                clear
                ;;
            who ) 
                [[ ! -z $SESSION_VM ]] && who "$SESSION_VM" || dispError "2" "$err_vm_co" 
                ;;
            host )
                [[ $SESSION_MODE == "admin" ]] && host "${args[1]}" "${args[2]}" "${args[3]}" || dispError "4" "$err_admin" 
                ;;
            rhost )
                [[ ! -z $SESSION_VM ]] && rhost || dispError "2" "$err_vm_co"
                ;;
            passwd )
                passwd "${args[1]}" "${args[2]}" "${args[3]}"
                ;;
            rusers )
                rusers
                ;;
            su )
                su "${args[1]}" "${args[2]}" "${args[3]}"
                ;;
            * )
                [[ ! -z $cmd ]] && dispError "2" "Incorrect command : \"${args[0]}\" doesn't exists"
                ;;
        esac
    done
}
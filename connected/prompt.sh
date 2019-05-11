#!/bin/bash

function startPrompt () {
    # Start programs
    asyncExec &
    async_exec_pid=$!
    executeCommand
}

function buildPrompt () {
    local host
    [[ $SESSION_MODE == "connect" ]] && host="$SESSION_VM"
    [[ $SESSION_MODE == "admin" ]] && host="rvsh"
    echo "\n${CY}$SESSION_USER${NC}@${GR}$host${NC}> "
}

function executeCommand () {
    # Wait for command & args
    while IFS= read -e -p "$(echo -e "$(buildPrompt)")" cmd; do
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
            connect )
                connect "${args[1]}"
                ;;
            write )
                write "${args[1]}" "$cmd"
                ;;
            * )
                [[ ! -z $cmd ]] && dispError "2" "Incorrect command : \"${args[0]}\" doesn't exists"
                ;;
        esac
    done
}

function asyncExec () {
    # Echo unread messages
    while [[ true ]]; do
        local unread_msgs=$(getVar "./usrs/$SESSION_USER.usr" "unread_msgs")
        if [[ ! -z $unread_msgs ]]; then
        echo -ne "HOLA HERE I AM\r"
            echo -ne "\n\n [${OR}Message${NC}] You received new message(s)"
            # Split messages
            local msgs=()
            IFS=')' read -r -a msgs <<< "$unread_msgs"
            for (( i=0; i<${#msgs[@]}; i++)); do
                local msg=${msgs[i]/(}
                local sender=$(echo $msg | cut -d, -f1)
                local content=$(echo $msg | cut -d, -f2)
                echo -ne "\n\n [${CY}$sender${NC}]\n\n $content"
                # Set prompt back
                echo -ne "\n$(buildPrompt)"
                # Send message to reads
                setVar "read_msgs" "./usrs/$SESSION_USER.usr" "push" "$unread_msgs"
                setVar "unread_msgs" "./usrs/$SESSION_USER.usr" "pop" "$unread_msgs"
            done
        fi 
        sleep 2
    done
}
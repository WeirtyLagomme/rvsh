#!/bin/bash

function startPrompt () {
    # Start programs
    asyncExec &
    async_exec_pid=$!
    promptCommand
}

function buildPrompt () {
    local host
    [[ $SESSION_MODE == "connect" ]] && host="$SESSION_VM"
    [[ $SESSION_MODE == "admin" ]] && host="rvsh"
    echo -e "\n${CY}$SESSION_USER${NC}@${GR}$host${NC}> "
}

function promptCommand () {
    # Wait for command & args
    local cmd args
    while read -e -p "$(buildPrompt)" cmd args; do
        # Save input to history if not empty
        [[ ! -z $cmd ]] && history -s "$cmd $args"
        # Must be an available command
        [[ ! -e "./cmds/$cmd.sh" ]] && dispError "2" "The command \"$cmd\" doesn't exists" && continue
        # Check & execute command
        checkCmd $cmd $args
    done
}

function asyncExec () {
    # Echo unread messages
    while [[ true ]]; do
        # Message inbox
        checkInbox
        # Account still active
        checkAccount
        sleep 2
    done
}
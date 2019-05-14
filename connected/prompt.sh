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
    echo -e "\n${CY}$SESSION_USER${NC}@${GR}$host${NC}> "
}

function executeCommand () {
    # Wait for command & args
    local cmd args
    while read -e -p "$(buildPrompt)" cmd args; do
        # Save input to history if not empty
        [[ ! -z $cmd ]] && history -s "$cmd $args"
        # Must be an available command
        if [[ ! -e "./cmds/$cmd.sh" ]] || [[ "$(type -t $cmd)" != "function" ]]; then
            dispError "2" "The command \"$cmd\" doesn't exists" && continue
        fi
        # Admin only
        local help_content="$(help${cmd^})"
        if [[ $help_content == *"[ADMIN-ONLY]"* ]] && [[ $SESSION_MODE != "admin" ]]; then
            dispError "4" "The command \"$cmd\" require admin privileges" && continue
        fi
        # VM connected only
        if [[ $help_content == *"[VMCO-ONLY]"* ]] && [[ -z $SESSION_VM ]]; then
            dispError "4" "You must be connected to a virtual machine in order to use \"$cmd\"" && continue
        fi
        # Execute command
        $cmd $args
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
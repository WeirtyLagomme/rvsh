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
        # Save input to log
        local log_mode="$SESSION_VM"
        [[ -z $log_mode ]] && log_mode="admin"
        echo -e "$(date)\t|\t$log_mode\t\t|\t$cmd $args" >> "./logs/$SESSION_USER.log"
        # Builtins cmds
        [[ ! -z "$(grep '^'"$cmd"'$' "./config/builtins.conf")" ]] && $cmd $args && continue
        # Check & execute command
        checkCommand $cmd $args
    done
}

function asyncExec () {
    while [[ true ]]; do
        # Message inbox
        checkInbox
        # Account still active
        checkAccount
        # Current VM still exists
        checkVm
        # Wait a bit
        sleep 2
    done
}
#!/bin/bash

# $1 : mode
# $2 : vm_name
# $3 : username
function su () {
    # Select mode
    local mode="$1"
    # Can't be empty
    [[ -z $mode ]] && dispError "3" "Missing argument : mode" && return 1
    case $mode in
        -c | -connect )
            # Wipe current vm session
            sed -e s/"($SESSION_USER,$SESSION_START,$SESSION_ID)"//g -i "./vms/$SESSION_VM.vm"
            connectModeLogin "$2" "$3"
            ;;
        -a | -admin )
            adminModeLogin
            ;;
        * )
            dispError "3" "Wrong argument : \"$mode\" isn't a valid mode to connect"
            ;;
    esac
}

function helpSu () {
    echo "Allows you to switch between users.
    
    > su [ -c | -connect ] vm_name username
    > su [ -a | -admin ]"
}
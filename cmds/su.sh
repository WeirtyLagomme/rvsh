#!/bin/bash

# $1 : args
function connectSu () {
    # Wipe current vm session if needed
    [[ ! -z $SESSION_VM ]] && sed -e s/"($SESSION_USER,$SESSION_START,$SESSION_ID)"//g -i "./vms/$SESSION_VM.vm"
    connectModeLogin "$@"
}

function adminSu () {
    # Wipe current vm session if needed
    [[ ! -z $SESSION_VM ]] && sed -e s/"($SESSION_USER,$SESSION_START,$SESSION_ID)"//g -i "./vms/$SESSION_VM.vm"
    adminModeLogin
}

function helpSu () {
    echo "Allows you to switch between users.
    
    > su -connect vm_name username
    > su -admin"
}
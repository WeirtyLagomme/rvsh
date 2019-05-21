#!/bin/bash

# $1 : args
function connectSu () {
    # Wipe current vm session if needed
    wipeSession && connectModeLogin "$@"
}

function adminSu () {
    # Wipe current vm session if needed
    wipeSession && adminModeLogin
}

function wipeSession () {
    [[ ! -z $SESSION_VM ]] && sed -e s/"($SESSION_USER,$SESSION_START,$SESSION_ID)"//g -i "./vms/$SESSION_VM.vm"
    return 0
}

function helpSu () {
    echo "Allows you to switch between users.
    
    > su -connect vm_name{file:!vm} username{file:usr}
    > su -admin"
}
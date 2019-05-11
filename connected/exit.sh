#!/bin/bash

function finish () {
    # Clear session from VM
    [[ ! -z $SESSION_ID ]] && sed -e s/"($SESSION_USER,$SESSION_START,$SESSION_ID)"//g -i "./vms/$SESSION_VM.vm"
    # Kill async process, redirect various errors to null
    kill $async_exec_pid > /dev/null 2>&1
    kill $current_input_pid > /dev/null 2>&1
    exit 0
}

trap finish EXIT
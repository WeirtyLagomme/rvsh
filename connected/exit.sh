#!/bin/bash

function finish () {
    # Clear session from vm
    if [[ ! -z $SESSION_VM ]]; then
        fileStream "remove" "./vms/$SESSION_VM/sessions" "$SESSION_USER,$SESSION_START,$SESSION_ID"
    fi
    # Kill async process, redirect various errors to null
    kill $async_exec_pid > /dev/null 2>&1
    kill $current_input_pid > /dev/null 2>&1
    exit 0
}

trap finish EXIT
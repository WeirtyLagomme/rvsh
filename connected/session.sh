#!/bin/bash

# Global session
SESSION_ID=""
SESSION_MODE=""
SESSION_USER=""
SESSION_VM=""
SESSION_START=""

# Start session
# $1 : mode
# $2 : username
# $3 : vm_name
function sessionStart () {
    # Set global session vars
    SESSION_ID=$(date +%s%N)
    SESSION_MODE="$1"
    SESSION_USER="$2"
    SESSION_VM="$3"
    SESSION_START=$(date)
    # Save user's session in VM
    if [[ $SESSION_MODE == "connect" ]]; then
        fileStream "append" "./vms/$SESSION_VM/sessions" "$SESSION_USER,$SESSION_START,$SESSION_ID"
    fi
    # Start prompt
    startPrompt
}
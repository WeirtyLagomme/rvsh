#!/bin/bash

# Global session
SESSION_ID=""
SESSION_USER=""
SESSION_VM=""
SESSION_START=""

# Start session
# $1 : mode
# $2 : username
# $3 : vm_name
sessionStart () {
    # Set global session vars
    SESSION_ID=$(date +%s%N)
    SESSION_USER=$2
    SESSION_VM=$3
    SESSION_START=$(date)
    # Select mode
    local mode=$1
    if [[ $mode == "connect" ]]; then
        connectMode
    elif [[ $mode == "admin" ]]; then
        adminMode
    fi
}
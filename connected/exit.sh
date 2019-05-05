#!/bin/bash

function finish () {
    # Clear session from VM
    [[ ! -z $SESSION_ID ]] && sed -e s/"($SESSION_USER,$SESSION_START,$SESSION_ID)"//g -i ./vms/flash.vm
    exit 0
}

trap finish EXIT
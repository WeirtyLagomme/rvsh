#!/bin/bash

# Display custom notif message
# $1 : notif type
# $2 : notif message
function dispNotif () {
    # Set local variables
    local type="$1"
    local msg="$2"
    # Variables shouldn't be empty
    if [[ -z $type ]] || [[ -z $msg ]]; then
        dispError "42" "Empty variables received in the \"dispNotif\" function"
        return 1
    fi
    # Translate notif type
    case $type in
        "0" )
            type="Virtual machines"
            ;;
        "1" )
            type="Users"
            ;;
    esac
    # Display message
    echo -e "\n[${GR}$type${NC}] $msg."
}
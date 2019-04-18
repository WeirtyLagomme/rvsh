#!/bin/bash

# Display custom error message
# $1 : error type
# $2 : error message
function dispError () {
    # Set local variables
    local type=$1
    local msg=$2
    # Variables shouldn't be empty
    if [ "$type" = "" ] || [ "$msg" = "" ]; then
        dispError "42" "Empty variables received in the \"dispError\" function"
        return 1
    fi
    # Translate error type
    case $type in
        "0" )
            type="Login"
            ;;
        "1" )
            type="VM connection"
            ;;
        "42" )
            type="Internal"
            ;;
    esac
    # Display message
    echo -e "[${RE}$type error${NC}] $msg. Use ${CY}nvsh -h${NC} for help."
}
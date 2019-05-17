#!/bin/bash

# Display custom error message
# $1 : error type
# $2 : error message
function dispError () {
    # Set local variables
    local type="$1"
    local msg="$2"
    # Variables shouldn't be empty
    if [[ -z $type ]] || [[ -z $msg ]]; then
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
        "2" )
            type="Command"
            ;;
        "3" )
            type="Argument"
            ;;
        "4" )
            type="Mode"
            ;;
        "42" )
            type="Internal"
            ;;
    esac
    # Display message
    local help_syntax="nvsh -help"
    [[ ! -z $SESSION_MODE ]] && help_syntax="help [command]"
    echo -e "\n[${RE}$type error${NC}] $msg. Use ${CY}$help_syntax${NC} for more."
}
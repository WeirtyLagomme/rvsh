#!/bin/bash

# $1 : var name
# $2 : error type
# $3 : var value
function emptyVar () {
    local name="$1"
    [[ -z $name ]] && dispError "42" "Empty var_name received in ${OR}emptyVar()${NC}" && return 1
    local error="$2"
    [[ -z $error ]] && dispError "42" "Empty error_type received in ${OR}emptyVar()${NC}" && return 1
    local value="$3"
    [[ -z $value ]] && dispError "$error" "The ${OR}$name${NC} variable is empty" && return 1
    return 0
}
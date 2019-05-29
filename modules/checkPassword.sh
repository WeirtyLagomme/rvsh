#!/bin/bash

# $1 : username
# $2 : password
function checkPassword () {
    # Set locals
    local username="$1" && emptyVar "username" "$username" "42" || return 1
    local password="$2" && emptyVar "password" "$password" "42" || return 1
    # Check password
    local correct_password=$(getVar "./usrs/$username/profile" "password")
    [[ $(hash "$password") != $correct_password ]] && echo "" && dispError "0" "Incorrect password" && return 1
    # No errors
    return 0
}
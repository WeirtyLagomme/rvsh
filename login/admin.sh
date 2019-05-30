#!/bin/bash

# Admin mode login
function adminModeLogin () {
    # Logins and validations
    local username password
    local username_validated password_validated
    # Prompt for username
    echo -e "\n[${OR}Admin mode${NC}] Authentication"
    while [[ $username_validated != 0 ]]; do
        echo -ne "\n => Username: "
        read username
        validateAdminUsername $username && username_validated=0
    done
    # Prompt for password
    while [[ $password_validated != 0 ]]; do
        echo -ne "\n => Password: "
        read -s password
        validateAdminPassword $password $username && password_validated=0
    done
    echo -e "\n\n[${GR}Admin mode${NC}] Successfuly Authenticated"
    # Start session
    sessionStart "admin" $username
}

# Check username validity
# $1 : username
function validateAdminUsername () {
    local username="$1"
    # Username can't be empty
    [[ -z $username ]] && echo "" && dispError "0" "Username can't be empty" && return 1
    # Incorrect username
    entityExists "true" "usr" "$username" "0" || return 1
    # User isn't admin
    local admin=$(getVar "./usrs/$username/profile" "admin")
    [[ $admin == "0" ]] && echo "" && dispError "0" "\"$username\" doesn't have admin privileges" && return 1
    # No errors
    return 0
}

# Check admin's password validity
# $1 : password
# $2 : username
function validateAdminPassword () {
    local password="$1"
    # Password can't be empty
    [[ -z $password ]] && echo "" && dispError "0" "Password can't be empty" && return 1
    # Incorrect password
    local username="$2"
    checkPassword "$username" "$password" || return 1
    # No errors
    return 0
}
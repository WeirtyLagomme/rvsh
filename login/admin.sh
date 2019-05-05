#!/bin/bash

# Admin mode login
function adminModeLogin () {
    # Logins and validations
    local username password
    local username_validated password_validated
    # Prompt for username
    while [[ $username_validated != 0 ]]; do
        echo -ne "[${OR}Admin mode${NC}] Authentication"
        echo -ne "\n=> Username:"
        read username
        validateAdminUsername $username && username_validated=0
    done
    # Prompt for password
    while [[ $password_validated != 0 ]]; do
        echo -ne "=> Password:"
        read -s password
        validateAdminPassword $username $password && password_validated=0
    done
    # Start session
    sessionStart "admin" $username
}

# Check username validity
# $1 : username
function validateAdminUsername () {
    # Username can't be empty
    local username=$1
    if [[ -z $username ]]; then
        echo ""
        dispError "0" "Username can't be empty"
        return 1
    fi
    # Incorrect username
    local usr=./usrs/$username.usr
    if [[ ! -e $usr ]]; then
        echo ""
        dispError "0" "Incorrect username : there is no user named \"$username\""
        return 1
    fi
    # User isn't admin
    local admin=$(getVar "$usr" "admin")
    if [[ -e $admin ]]; then
        echo ""
        dispError "0" "\"$username\" doesn't have admin privileges"
        return 1
    fi
    return 0
}

# Check admin's password validity
# $1 : username
# $2 : password
function validateAdminPassword () {
    # Password can't be empty
    local password=$2
    if [[ -z $password ]]; then
        echo ""
        dispError "0" "Password can't be empty"
        return 1
    fi
    # Incorrect password
    local username=$1
    local usr=./usrs/$username.usr
    local correct_password=$(getVar "$usr" "password")
    if [[ $password != $correct_password ]]; then
        echo ""
        dispError "0" "Incorrect password"
        return 1
    fi
    return 0
}
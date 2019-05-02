#!/bin/bash

# Admin mode
function adminMode () {
    # Logins
    local username password
    # Ask for logins
    echo -ne "[${OR}Admin mode${NC}] Authentication"
    echo -ne "\n=> Username:"
    read username
    validateAdminUsername $username
    echo -ne "=> Password:"
    read -s password
    validateAdminPassword $username $password
    # Start session
    sessionStart $username $curr_is_admin
}

# Check username validity
# $1 : username
function validateAdminUsername () {
    # Username can't be empty
    local username=$1
    if [ "$username" = "" ]; then
        echo ""
        dispError "0" "Username can't be empty"
        adminMode
    fi
    # Incorrect username
    local usr=./usrs/$username.usr
    if [ ! -f $usr ]; then
        echo ""
        dispError "0" "Incorrect username : there is no user named \"$username\""
        adminMode
    fi
    # User isn't admin
    local admin=$(getVar "$usr" "admin")
    if [ "$admin" = "0" ]; then
        echo ""
        dispError "0" "$username doesn't have admin privileges"
        adminMode
    fi
}

# Check admin's password validity
# $1 : username
# $2 : password
function validateAdminPassword () {
    # Password can't be empty
    local password=$2
    if [ "$password" = "" ]; then
        echo ""
        dispError "0" "Password can't be empty"
        adminMode
    fi
    # Incorrect password
    local username=$1
    local usr=./usrs/$username.usr
    local correct_password=$(getVar "$usr" "password")
    if [ "$password" != "$correct_password" ]; then
        echo ""
        dispError "0" "Incorrect password"
        adminMode
    fi
}
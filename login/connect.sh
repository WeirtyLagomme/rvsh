#!/bin/bash

# Connect mode login
# $1 : vm_name
# $2 : username
function connectModeLogin () {
    local vm_name="$1"
    local username="$2"
    local password password_validated
    # Validate VM name and username
    validateVM $vm_name
    validateUser $vm_name $username
    # Ask and validate password
    echo -e "\n[${OR}Connect mode${NC}] Authentication"
    while [[ $password_validated != 0 ]]; do
        echo -ne "\n => Password: "
        read -s password
        validateConnectPassword $username $password && password_validated=0
    done
    echo -e "\n\n[${GR}Connect mode${NC}] Successfuly Authenticated"
    # Connect to VM
    sessionStart "connect" $username $vm_name
}


# Check VM name validity
# $1 : vm_name
function validateVM () {
    # VM name can't be empty
    local vm_name="$1"
    if [[ -z $vm_name ]]; then
        dispError "1" "VM name is required to connect"
        exit 128 # Invalid arg
    fi
    # Incorrect VM name
    local vm=./vms/$vm_name.vm
    if [[ ! -e $vm ]]; then
        dispError "1" "Incorrect VM name : \"$vm_name\" doesn't exists"
        exit 128 # Invalid arg
    fi
}

# Check user validity
# $1 : vm_name
# $2 : username
function validateUser () {
    # VM name can't be empty
    local username="$2"
    if [[ -z $username ]]; then
        dispError "1" "Username is required to connect"
        exit 128 # Invalid arg
    fi
    # Incorrect username
    local usr=./usrs/$username.usr
    if [[ ! -e $usr ]]; then
        echo ""
        dispError "0" "Incorrect username : there is no user named \"$username\""
        exit 128 # Invalid arg
    fi
    # User must be authorized on VM
    local vm_name="$1"
    local vm="./vms/$vm_name.vm"
    local authorized_users=$(getVar "$vm" "authorized_users")
    if [[ $authorized_users != *"($username)"* ]]; then
        dispError "1" "You're not authorized to connect to \"$vm_name\""
        exit 128 # Invalid arg
    fi
}

# Check user's password validity
# $1 : username
# $2 : password
function validateConnectPassword () {
    # Password can't be empty
    local password="$2"
    if [[ -z $password ]]; then
        echo ""
        dispError "0" "Password can't be empty"
        return 1
    fi
    # Incorrect password
    local username="$1"
    local usr=./usrs/$username.usr
    local correct_password=$(getVar "$usr" "password")
    if [[ $password != $correct_password ]]; then
        echo ""
        dispError "0" "Incorrect password"
        return 1
    fi
    return 0
}
#!/bin/bash

# Connect mode login
# $1 : vm_name
# $2 : username
function connectModeLogin () {
    local vm_name="$1"
    local username="$2"
    local password password_validated
    # Validate VM name and username
    validateVM $vm_name || return 1
    validateUser $username $vm_name || return 1
    # Ask and validate password
    echo -e "\n[${OR}Connect mode${NC}] Authentication"
    while [[ $password_validated != 0 ]]; do
        echo -ne "\n => Password: "
        read -s password
        validateConnectPassword $password $username && password_validated=0
    done
    echo -e "\n\n[${GR}Connect mode${NC}] Successfuly Authenticated"
    # Connect to VM
    sessionStart "connect" $username $vm_name
}


# Check VM name validity
# $1 : vm_name
function validateVM () {
    local vm_name="$1"
    # VM name can't be empty
    [[ -z $vm_name ]] && dispError "1" "VM name is required to connect" && return 1
    # Incorrect VM name
    fileExists "$vm_name" "vm" "1" "true" || echo "" && return 1
    # No errors
    return 0
}

# Check user validity
# $1 : username
# $2 : vm_name
function validateUser () {
    local username="$1"
    # VM name can't be empty
    [[ -z $username ]] && dispError "1" "Username is required to connect" && return 1
    # Incorrect username
    fileExists "$username" "usr" "0" "true" || echo "" && return 1
    # User must be authorized on VM
    local vm_name="$2"
    if ! isInVar "$username" "./vms/$vm_name.vm" "authorized_users"; then 
        dispError "1" "You're not authorized to connect to \"$vm_name\""
        return 1
    fi
    # No errors
    return 0
}

# Check user's password validity
# $1 : password
# $2 : username
function validateConnectPassword () {
    local password="$1"
    # Password can't be empty
    [[ -z $password ]] && echo "" && dispError "0" "Password can't be empty" && return 1
    # Incorrect password
    local username="$2"
    checkPassword "$username" "$password" || echo "" && dispError "0" "Incorrect password" && return 1
    # No errors
    return 0
}
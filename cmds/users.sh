#!/bin/bash

# $1 : mode
# $2 : username
# $3 : password || properties
# $4 : admin || null
# $5 : vm_name || null
function users () {
    # Mode shouldn't be empty
    local mode="$1"
    [[ -z $mode ]] && dispError "3" "Missing argument : mode" && return 1 # DO A FUCKING VERSION IF THIS IN DISPERROR
    # Username shouldn't be empty
    local username="$2"
    [[ -z $username ]] && dispError "3" "Missing argument : username" && return 1
    # Select mode
    case $mode in
        -a | -add )
            local admin="$4"
            local vm_names="$5"
            addUser "$username" "$password" "$admin" "$vm_names"
            ;;
        -r | -remove )
            removeUser "$username"
            ;;
        -u | -update )
            local properties="$3"
            updateUser $username 
            ;;
        * )
            dispError "3" "Wrong argument : \"$mode\" isn't an existing mode"
        ;;
    esac
}

# $1 : username
# $2 : password
# $3 : [admin]
# $4 : [vm_name | (vm_name...)]
function addUser () {
    # username must be available
    local username="$1"
    if [[ -e "./usrs/$username.usr" ]]; then
        dispError "3" "The username \"$username\" isn't available"
        return 1
    fi
    # Username min length is 3
    if (( ${#username} < 3 )); then
        dispError "3" "Username must have a min length of 3"
        return 1
    fi
    # Validate username format
    if [[ ! $username =~ ^[A-Za-z0-9_]*$ ]]; then
        dispError "3" "Username can only contain the following caracters : [A-Za-z0-9_]"
        return 1
    fi
    # password min length is 3
    local password="$2"
    if (( ${#password} < 3 )); then
        dispError "3" "Password must have a min length of 3"
        return 1
    fi
    # Validate password format
    if [[ ! $password =~ ^[A-Za-z0-9_]*$ ]]; then
        dispError "3" "Password can only contain the following caracters : [A-Za-z0-9_]"
        return 1
    fi
    # Validate admin
    local admin="$3"
    if [[ ! -z $admin ]]; then
        if [[ $admin != "0" && $admin != "1" ]]; then
            dispError "3" "The admin argument must be either 0 or 1"
            return 1
        fi
    fi
    # Validate vms
    local vm_names="$4"
    local auth_vm_names=()
    if [[ ! -z $vm_names ]]; then
        if [[ $vm_names =~ ^[A-Za-z0-9_]*$ ]]; then # Single VM
            [[ ! -e "./vms/$vm_names.vm" ]] && dispError "3" "There's no \"$vm_names\" virtual machine" && return 1
            auth_vm_names+=( "$vm_names" )
        elif [[ $vm_names =~ ^\(([A-Za-z0-9_]*,?)*\)$ ]]; then # Array of vms
            # Remove ()
            vm_names="${vm_names:1:${#vm_names}-2}"
            IFS=',' read -r -a auth_vm_names <<< "$vm_names"
            for i in "${auth_vm_names[@]}"; do
                [[ ! -e "./vms/${auth_vm_names[$i]}.vm" ]] && dispError "3" "There's no vm named \"${auth_vm_names[$i]}\"" && return 1
            done
        else # Wrong format
            dispError "3" "Wrong vm_name(s) format : (vm_name_1, vm_name_2...) or vm_name" && return 1
        fi
    fi
    # Create User file
    cp "./config/default.usr" "./usrs/$username.usr"
    # Fill user file
    setVar "password" "./usrs/$username.usr" "push" "$password"
    [[ ! -z $admin ]] && setVar "admin" "./usrs/$username.usr" "push" "$admin"
    if [[ ! -z $vm_names ]]; then
        local vm_name
        for vm_name in "${auth_vm_names[@]}"; do
            setVar "authorized_users" "./vms/$vm_name.vm" "push" "($username)"
            setVar "authorized_vms" "./usrs/$username.usr" "push" "($vm_name)"
        done
    fi
    dispNotif "0" "The user \"$username\" has been successfuly created"
}

# $1 : username
function removeUser () {
    local username="$1"
    # User must exists
    local user="./usrs/$username.usr"
    [[ ! -e $user ]] && dispError "3" "The user \"$username\" doesn't exists" && return 1
    # Remove from vms auth
    local authorized_vms=$(getVar "./usrs/$username.usr" "authorized_vms")
    authorized_vms=${authorized_vms//(}
    local auth_vm_names=()
    IFS=')' read -r -a auth_vm_names <<< "$authorized_vms"
    local vm_name
    for vm_name in "${auth_vm_names[@]}"; do
        setVar "authorized_users" "./vms/$vm_name.vm" "pop" "($username)"
    done
    # Delete user file
    rm "$user"
    dispNotif "1" "The user \"$username\" has been successfuly deleted"
    # If current user, logout
    checkAccount
}

# $1 : username
# $2 : properties
function updateUser () {
    local username="$1"
    local properties="$2"
    [[ -z $properties ]] && dispError "3" "Missing argument : properties" && return 1
    # properties format
    if [[ $properties =~ ^\(.*\)$ ]]; then # Array of properties
        for property in $properties; do
            local values=.....
        done
    elif [[ $properties =~ ^[A-Za-z0-9_]*(\-|\+)?=[A-Za-z0-9_]*$ ]]; then # One property
        local values=$(echo $properties | cur -d= -f2)
        if [[ $values =~ ^[A-Za-z0-9_]*$ ]]; then # One value
        elif [[ $values =~ ^\(([A-Za-z0-9_]*,?)*\)$ ]]; then # Array of values
        else # Wront format
            dispError "3" "Wrong values format : (password=<password>,vms+=(<vm_name>,...),vms-=(<vm_name>,...)...) | password=<password>" && return 1
        fi
    else # Wront format
        dispError "3" "Wrong properties format : (password=<password>,vms+=(<vm_name>...),vms-=(<vm_name>...)...) | password=<password>" && return 1
    fi
}

function helpUsers () {
    echo "As admin, allows you to add, remove or manage user informations such as password or virtual machine's access.
    
    > users ( -a | -add ) username password [admin] [(vm_name_1,vm_name_2... )]
    > users ( -r | -remove ) username
    > users ( -u | -update ) username [(password=<password>,vms+=(<vm_name>...),vms-=(<vm_name>...)...) | password=<password>]"
}
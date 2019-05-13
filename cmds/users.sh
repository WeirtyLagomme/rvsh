#!/bin/bash

# $1 : mode
# $2 : username
# $3 : password || property
# $4 : admin || property
# $5 : vm_name || property
# $6 -> $n : any property to update
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
        # Single VM
        if [[ ! $vm_names =~ ^\(([A-Za-z0-9_]*,?)*\)$ ]]; then
            [[ ! -e "./vms/$vm_names.vm" ]] && dispError "3" "There's no \"$vm_names\" virtual machine" && return 1
            auth_vm_names+=( "$vm_names" )
        else # Array of vms
            # Remove ()
            vm_names="${vm_names:1:${#vm_names}-2}"
            IFS=',' read -r -a auth_vm_names <<< "$vm_names"
            for i in "${auth_vm_names[@]}"; do
                [[ ! -e "./vms/${auth_vm_names[$i]}.vm" ]] && dispError "3" "There's no vm named \"${auth_vm_names[$i]}\"" && return 1
            done
        fi
    fi
    # Create User file
    cp "./config/default.usr" "./usrs/$username.usr"
    # Fill user file
    setVar "password" "./usrs/$username.usr" "push" "$password"
    [[ ! -z $admin ]] && setVar "admin" "./usrs/$username.usr" "push" "$admin"
    if [[ ! -z $vm_names ]]; then
        for vm_name in "${auth_vm_names[@]}"; do
            setVar "authorized_users" "./vms/${vm_name}.vm" "push" "($username)"
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
    # Delete user
    rm "$user"
    dispNotif "1" "The user \"$username\" has been successfuly deleted"
    [[ $username == $SESSION_USER ]] && exit 0
}

function helpUsers () {
    echo "As admin, allows you to add, remove or manage user informations such as password or virtual machine's access.
    
    > users ( -a | -add ) username password [admin] [(vm_name_1,vm_name_2... )]
    > users ( -r | -remove ) username
    > users ( -u | -update ) username [password=<password>, vms+=(<vm_name>...), vms-=(<vm_name>...)...]"
}
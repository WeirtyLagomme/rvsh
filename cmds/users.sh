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
    # Must be an available mode
    local method=$(getMethod $mode)
    [[ -z $method ]] && dispError "2" "The mode \"$mode\" doesn't exists" && return 1
    # Username shouldn't be empty
    local username="$2"
    [[ -z $username ]] && dispError "3" "Missing argument : username" && return 1
    # Execute mode
    $method "${@:2}"
}

# $1 : username
# $2 : password
# $3 : [admin]
# $4 : [vm_name | (vm_name...)]
function addUsers () {
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
    # Admin shouldn't be empty
    [[ -z $admin ]] && dispError "3" "Missing argument : admin" && return 1
    [[ $admin != "0" && $admin != "1" ]] && dispError "3" "The admin argument must be either 0 or 1" && return 1
    # Validate vms
    local vm_names="$4"
    local auth_vm_names=()
    if [[ ! -z $vm_names ]]; then # Could work with diff args instead of using ","
        if [[ $vm_names =~ ^([A-Za-z0-9_]*,?)*$ ]]; then
            IFS=',' read -r -a auth_vm_names <<< "$vm_names"
            for i in "${auth_vm_names[@]}"; do
                [[ ! -e "./vms/${auth_vm_names[$i]}.vm" ]] && dispError "3" "There's no vm named \"${auth_vm_names[$i]}\"" && return 1
            done
        else # Wrong format
            dispError "3" "Wrong vm_name(s) format : vm_name_1,vm_name_2..." && return 1
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
function removeUsers () {
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
function updateUsers () {
    local username="$1"
    local properties=("${@:2}")
    [[ -z $properties ]] && dispError "3" "Missing argument : properties" && return 1

    for property in "${properties[@]}"; do
        # Check format
        if [[ ! $property =~ ^[A-Za-z0-9_]{1,}(\+|\-)?=([A-Za-z0-9_]{1,},?){1,}$ ]]; then
            dispError "3" "Wrong format for property : \"$property\"" && return 1
        fi
        # Manage vms
        if [[ $property =~ ^vms(\+|\-)= ]]; then
            local vm_names="$(echo "$property" | cut -d = -f2)"
            # VM names can't be empty
            [[ -z $vm_names ]] && dispError "3" "Missing value(s) for the vms property" && return 1
            local auth_vm_names=(${vm_names//,/ })
            # VMS must exist
            for auth_vm_name in "${auth_vm_names[@]}"; do
                [[ ! -e "./vms/$auth_vm_name.vm" ]] && dispError "3" "There's no vm named \"$auth_vm_name\"" && return 1
            done
            # Push or Pop
            local action="push"
            [[ $property == *"-="* ]] && action="pop"
            # Update vms auths
            for auth_vm_name in "${auth_vm_names[@]}"; do
                local currently_auth_vms="$(getVar "./usrs/$username.usr" "authorized_vms")"
                # Don't push twice or pop if it isn't necessary
                [[ $action == "push" ]] && [[ $currently_auth_vms == *"($auth_vm_name)"* ]] && continue
                [[ $action == "pop" ]] && [[ $currently_auth_vms != *"($auth_vm_name)"* ]] && continue
                # Do the job
                setVar "authorized_users" "./vms/$auth_vm_name.vm" "$action" "($username)"
                setVar "authorized_vms" "./usrs/$username.usr" "$action" "($auth_vm_name)"
            done
            # Notif
            local vm_update_notif="now"
            [[ $action == "pop" ]] && vm_update_notif="no longer"
            dispNotif "1" "The user \"$username\" is $vm_update_notif authorized to connect to the following virtual machine(s) : ${vm_names//,/, }"
        fi
        # Manage password
        if [[ $property =~ ^password= ]]; then
            local new_password="$(echo "$property" | cut -d = -f2)"
            [[ -z $new_password ]] && dispError "3" "Missing value for the password property" && return 1
            # New password min length is 3
            if (( ${#new_password} < 3 )); then
                dispError "3" "New password length must have a min length of 3" && return 1
            fi
            # Validate new password format
            if [[ ! $new_password =~ ^[A-Za-z0-9_]*$ ]]; then
                dispError "3" "The new password can only contain the following caracters : [A-Za-z0-9_]"
                return 1
            fi
            # Set new password
            setVar "password" "./usrs/$username.usr" "replace" "$new_password"
            dispNotif "1" "$username's password has been updated"
        fi
        # Manage admin privileges
        if [[ $property =~ ^admin= ]]; then
            local admin="$(echo "$property" | cut -d = -f2)"
            [[ -z $admin ]] && dispError "3" "Missing value for the admin property" && return 1
            [[ $admin != "0" && $admin != "1" ]] && dispError "3" "Incorrect value for the admin property" && return 1
            # Set admin property
            setVar "admin" "./usrs/$username.usr" "replace" "$admin"
            dispNotif "1" "$username's admin privileges have been updated"
        fi
    done
}

function helpUsers () {
    echo "Allows you to add, remove or manage user's password and virtual machine's access.
    
    > users ( -a | -add ) username password admin [vm_name_1,vm_name_2...]
    > users ( -r | -remove ) username
    > users ( -u | -update ) username [password=new_password] [admin=( 0 | 1 )] [vms( + | - )=vm_name_1,vm_name_2...]"
}

function needUsers () {
    echo "admin"
}
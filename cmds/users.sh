#!/bin/bash

# $1 : username
# $2 : password
# $3 : admin
# ${@:4} : vm_names
function addUsers () {
    local username="$1"
    local password="$2"
    local admin="$3"
    [[ $admin != "0" && $admin != "1" ]] && dispError "3" "The admin argument must be either 0 or 1" && return 1
    # Validate vms
    local vm_names="${@:4}"
    local auth_vm_names
    if [[ ! -z $vm_names ]]; then 
        if [[ $vm_names =~ ^([A-Za-z0-9_]*[[:space:]]?)*$ ]]; then
            auth_vm_names=($vm_names)
            for vm_name in "${auth_vm_names[@]}"; do
                [[ ! -e "./vms/$vm_name.vm" ]] && dispError "3" "There's no vm named ${OR}vm_name${NC}" && return 1
            done
        else # Wrong format
            dispError "3" "Wrong vm_name(s) format : vm_name_1,vm_name_2..." && return 1
        fi
    fi
    # Create User file
    cp "./config/default.usr" "./usrs/$username.usr"
    # Fill user file
    setVar "password" "./usrs/$username.usr" "push" "$(hash "$password")"
    setVar "admin" "./usrs/$username.usr" "push" "$admin"
    if [[ ! -z $vm_names ]]; then
        for vm_name in "${auth_vm_names[@]}"; do
            setVar "authorized_users" "./vms/$vm_name.vm" "push" "($username)"
            setVar "authorized_vms" "./usrs/$username.usr" "push" "($vm_name)"
        done
    fi
    dispNotif "0" "The user ${OR}$username${NC} has been successfuly created"
}

# $1 : username
function removeUsers () {
    local username="$1"
    # Remove from vms auth
    local authorized_vms=($(getVar "./usrs/$username.usr" "authorized_vms"))
    for vm_name in "${authorized_vms[@]}"; do
        setVar "authorized_users" "./vms/$vm_name.vm" "pop" "($username)"
    done
    # Delete user file
    rm "./usrs/$username.usr"
    dispNotif "1" "The user ${OR}$username${NC} has been successfuly deleted"
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
            dispError "3" "Wrong format for property : ${OR}$property${NC}" && return 1
        fi
        # Manage vms
        if [[ $property =~ ^vms(\+|\-)= ]]; then
            local vm_names="$(echo "$property" | cut -d = -f2)"
            # VM names can't be empty
            [[ -z $vm_names ]] && dispError "3" "Missing value(s) for the vms property" && return 1
            local auth_vm_names=(${vm_names//,/ })
            # VMS must exist
            for auth_vm_name in "${auth_vm_names[@]}"; do
                [[ ! -e "./vms/$auth_vm_name.vm" ]] && dispError "3" "There's no vm named ${OR}$auth_vm_name${NC}" && return 1
            done
            # Push or Pop
            local action="push"
            [[ $property == *"-="* ]] && action="pop"
            # Update vms auths
            for auth_vm_name in "${auth_vm_names[@]}"; do
                local currently_auth_vms="$(getVar "./usrs/$username.usr" "authorized_vms")"
                # Don't push twice or pop if it isn't necessary
                [[ $action == "push" ]] && [[ $currently_auth_vms =~ (^|[[:space:]])$auth_vm_name($|[[:space:]]) ]] && continue
                [[ $action == "pop" ]] && [[ ! $currently_auth_vms =~ (^|[[:space:]])$auth_vm_name($|[[:space:]]) ]] && continue
                # Do the job
                setVar "authorized_users" "./vms/$auth_vm_name.vm" "$action" "($username)"
                setVar "authorized_vms" "./usrs/$username.usr" "$action" "($auth_vm_name)"
            done
            # Notif
            local vm_update_notif="now"
            [[ $action == "pop" ]] && vm_update_notif="no longer"
            dispNotif "1" "The user ${OR}$username${NC} is $vm_update_notif authorized to connect to the following virtual machine(s) : ${vm_names//,/, }"
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
            setVar "password" "./usrs/$username.usr" "replace" "$(hash "$new_password")"
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
    
    #> admin
    > users -add username{file:!usr,format:norm,min:3} password{format:norm,min:3} admin [vm_name_1,vm_name_2...]
    > users -remove username{file:usr}
    > users -update username{file:usr} [password=new_password] [admin=(0|1)] [vms(+|-)=vm_name_1,vm_name_2...]"
}
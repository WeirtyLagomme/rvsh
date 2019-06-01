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
                entityExists "true" "vm" "$vm_name" "3" || return 1
            done
        else # Wrong format
            dispError "3" "Wrong vm_name(s) format : vm_name_1,vm_name_2..." && return 1
        fi
    fi
    # Create user directory
    mkdir "./usrs/$username" && cp -R "./config/defaults/usr/." "$_"
    # Fill user file
    setVar "password" "./usrs/$username/profile" "push" "$(hash "$password")"
    setVar "admin" "./usrs/$username/profile" "push" "$admin"
    if [[ ! -z $vm_names ]]; then
        for vm_name in "${auth_vm_names[@]}"; do
            fileStream "append" "./vms/$vm_name/auths" "$username"
            echo "$vm_name" >> "./usrs/$username/auths"
            mkdir -p "./vms/$vm_name/root/$username/{home,share,dev,tmp}"
        done
    fi
    dispNotif "0" "The user ${OR}$username${NC} has been successfuly created"
}

# $1 : username
function removeUsers () {
    local username="$1"
    # Remove from vms auth and remove ~/
    while read vm_name; do
        fileStream "remove" "./vms/$vm_name/auths" "$username"
        rm -rf "./vms/$vm_name/root/$username"
    done < "./usrs/$username/auths"
    # Delete user file
    rm -rf "./usrs/$username"
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
                entityExists "true" "vm" "$auth_vm_name" "3" || return 1
            done
            # Append or remove
            local action="append"
            [[ $property == *"-="* ]] && action="remove"
            # Update vms auths
            for auth_vm_name in "${auth_vm_names[@]}"; do
                local currently_auth_vms=$(grep '/^'"$auth_vm_name"'$/' "./usrs/$username/auths")
                # Don't append twice or remove if it isn't necessary
                [[ $action == "append" ]] && [[ -z $currently_auth_vms ]] && continue
                [[ $action == "remove" ]] && [[ ! -z $currently_auth_vms ]] && continue
                # Do the job
                fileStream "$action" "./vms/$auth_vm_name/auths" "$username"
                fileStream "$action" "./usrs/$username/auths" "$auth_vm_name"
            done
            # Notif
            local vm_update_notif="now"
            [[ $action == "remove" ]] && vm_update_notif="no longer"
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
            setVar "password" "./usrs/$username/profile" "replace" "$(hash "$new_password")"
            dispNotif "1" "$username's password has been updated"
        fi
        # Manage admin privileges
        if [[ $property =~ ^admin= ]]; then
            local admin="$(echo "$property" | cut -d = -f2)"
            [[ -z $admin ]] && dispError "3" "Missing value for the admin property" && return 1
            [[ $admin != "0" && $admin != "1" ]] && dispError "3" "Incorrect value for the admin property" && return 1
            # Set admin property
            setVar "admin" "./usrs/$username/profile" "replace" "$admin"
            dispNotif "1" "$username's admin privileges have been updated"
        fi
    done
}

function helpUsers () {
    echo "Allows you to add, remove or manage user's password and virtual machine's access.
    
    #> admin
    > users -add username{file:!usr,format:norm,min:3} password{format:norm,min:3} admin [vm_name_1 vm_name_2...]
    > users -remove username{file:usr}
    > users -update username{file:usr} [password=new_password] [admin=(0|1)] [vms(+|-)=vm_name_1,vm_name_2...]"
}
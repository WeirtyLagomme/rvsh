#!/bin/bash

# $1 : current password
# $2 : new password
# $3 : new password confirm
function passwd () {
    # Check current password
    local curr_passwd="$1"
    local usr=./usrs/$SESSION_USER.usr
    local correct_password=$(getVar "$usr" "password")
    if [[ $(hash "$curr_passwd") != $correct_password ]]; then
        dispError "0" "Incorrect current password"
        return 1
    fi
    # New password min length is 3
    local new_passwd="$2"
    if (( ${#new_passwd} < 3 )); then
        dispError "3" "New password length must have a min length of 3"
        return 1
    fi
    # Validate new password format
    if [[ ! $new_passwd =~ ^[A-Za-z0-9_]*$ ]]; then
        dispError "3" "The new password can only contain the following caracters : [A-Za-z0-9_]"
        return 1
    fi
    # New password and confirmation must be equal
    local new_passwd_conf="$3"
    if [[ $new_passwd != $new_passwd_conf ]]; then
        dispError "3" "New password and password confirmation don't match"
        return 1
    fi
    # Set new password
    setVar "password" "./usrs/$SESSION_USER.usr" "replace" "$(hash "$new_passwd")"
    dispNotif "1" "$SESSION_USER's password has been changed"
}

# Help
function helpPasswd () {
    echo "Change your password.
    
    > passwd current_password new_password{min:3,format:name} confirm_new_password"
}
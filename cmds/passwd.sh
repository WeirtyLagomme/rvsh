#!/bin/bash

# $1 : current password
# $2 : new password
# $3 : new password confirm
function passwd () {
    # Check current password
    local curr_passwd="$1"
    checkPassword "$SESSION_USER" "$curr_passwd" || dispError "0" "Incorrect current password" && return 1
    # New password and confirmation must be equal
    local new_passwd_conf="$3"
    if [[ $new_passwd != $new_passwd_conf ]]; then
        dispError "3" "New password and password confirmation don't match"
        return 1
    fi
    # Set new password
    setVar "password" "./usrs/$SESSION_USER/profile" "replace" "$(hash "$new_passwd")"
    dispNotif "1" "$SESSION_USER's password has been updated"
}

# Help
function helpPasswd () {
    echo "Change your password.
    
    > passwd current_password new_password{min:3,format:norm} confirm_new_password"
}
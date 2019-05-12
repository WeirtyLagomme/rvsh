#!/bin/bash

function checkAccount () {
    local user="./usrs/$SESSION_USER.usr"
    [[ -e  $user ]] && return 0
    dispNotif "1" "Your account has been deleted"
    exit 0
}
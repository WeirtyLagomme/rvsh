#!/bin/bash

function checkAccount () {
    [[ -d  "./usrs/$SESSION_USER" ]] && return 0
    dispNotif "1" "Your account has been deleted"
    exit 0
}
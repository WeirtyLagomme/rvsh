#!/bin/bash

function whoami () {
    local admin=$(getVar "./usrs/$SESSION_USER/profile" "admin")
    echo -e "\n [${BL}$SESSION_USER${NC}]"
    echo -e "\n ID : $SESSION_ID"
    echo -e "\n Admin : $admin"
    echo -e "\n Authorized virtual machines :"
    echo -e "\n$(sed 's/^/ > /g' < ./usrs/$SESSION_USER/auths)"
}

function helpWhoami () {
    echo "Display information about your user account.
    
    > whoami"
}
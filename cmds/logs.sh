#!/bin/bash

# $1 : username
function logs () {
    local username="$1"
    echo -e "\n [${CY}Logs of $username${NC}]\n"
    echo -e "$(sed -e $'s/^/ /g' < "./logs/tom.log")"
}

function helpLogs () {
    echo "Display logs of specified user
    
    #> admin
    > logs username{file:usr}"
}
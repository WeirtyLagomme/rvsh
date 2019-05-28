#!/bin/bash

# - - - - - < IMPORTS > - - - - - #

for file in ./*/*.sh; do source "$file"; done;

# - - - - - < SELECT MODE > - - - - - #

case $1 in
    -c | -connect ) 
        connectModeLogin $2 $3
        ;;
    -a | -admin )
        adminModeLogin
        ;;
    -h | -help )
        helpMode
        ;;
    -t )
        sessionStart "admin" "tom"
        echo -e "\n IDEAS : Handle mkdir, touch, cd & ls in ./vm_name/* and share files between connected vms"
        ;;
    * )
        error_msg="Invalid argument : the \"$1\" flag doesn't exists"
        [[ -z $1 ]] && error_msg="Missing argument : no argument(s) provided"
        dispError "3" "$error_msg"
        exit 128 # Invalid arg
        ;;
esac
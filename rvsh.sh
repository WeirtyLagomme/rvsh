#!/bin/bash

# - - - - - < IMPORTS > - - - - - #

for file in ./*/*; do source "$file"; done;

# - - - - - < USE MODE > - - - - - #

case $1 in
    -c | -connect ) 
        connectModeLogin $2 $3
        ;;
    -a | -admin )
        adminModeLogin
        ;;
    -h | --help )
        help
        ;;
    -t )
        echo "test command"
        ;;
    * )
        error_msg="Invalid argument : the \"$1\" flag doesn't exists"
        [[ -z $1 ]] && error_msg="Missing argument : no argument(s) provided"
        dispError "3" "$error_msg"
        exit 128 # Invalid arg
        ;;
esac
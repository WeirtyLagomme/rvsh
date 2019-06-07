#!/bin/bash

# - - - - - < IMPORTS > - - - - - #

for file in ./*/*.sh; do source "$file"; done;

# - - - - - < DEFAULT ADMIN > - - - - - #

command ls ./usrs/*/ 2> /dev/null || addUsers "modo" "modo" "1"

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
        #sessionStart "admin" "tom"
        sessionStart "connect" "tom" "flash"
        ;;
    * )
        error_msg="Invalid argument : the \"$1\" flag doesn't exists"
        [[ -z $1 ]] && error_msg="Missing argument : no argument(s) provided"
        dispError "3" "$error_msg"
        exit 128 # Invalid arg
        ;;
esac
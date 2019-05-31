#!/bin/bash

# $1 : lookup
function touch () {
    # Set locals
    local lookup="$1"
    # Set local path
    local path=$(buildPath "$lookup")
    # Error handler
    local error=$(command touch "$path" 2> /dev/null || echo "error")
    [[ $error == "error" ]] && dispError "2" "Incorrect path : ${OR}$lookup${NC}" && return 1
    dispNotif "2" "The file ${OR}$(basename $lookup)${NC} has been successfuly created"
}

function helpTouch () {
    echo "Create a file to the specified path.

    #> connect
    > touch path"
}
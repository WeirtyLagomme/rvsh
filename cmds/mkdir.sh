#!/bin/bash

# $1 : lookup
function mkdir () {
    # Set locals
    local lookup="$1"
    # Set local path
    local path=$(buildPath "$lookup")
    # Should be a directory
    [[ ! -d "$path" ]] && dispError "2" "Incorrect path to make directory" && return 1
    # Error handler
    local error=$(command mkdir "$path" 2> /dev/null || echo "error")
    [[ $error == "error" ]] && dispError "2" "Incorrect path : ${OR}$lookup${NC}" && return 1
    # Display success notification
    dispNotif "2" "The ${OR}$lookup${NC} directory has been successfuly created"
}

function helpMkdir () {
    echo "Create a new directory at the specified path.

    #> connect
    > mkdir path"
}
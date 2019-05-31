#!/bin/bash

# $1 : lookup
function cd () {
    # Set locals
    local lookup="$1"
    # Set local path
    local path=$(buildPath "$lookup" "true")
    # Error handler
    [[ $(cut -d ' ' -f1 <<< "$path") == "dispError" ]] && eval $path && return 1
    # Should be a directory
    [[ ! -d "$path" ]] && dispError "2" "Incorrect path to move" && return 1
    # Update session path
    SESSION_DIR="${path#./vms/$SESSION_VM/root/$SESSION_USER}"
    [[ -z $SESSION_DIR ]] && SESSION_DIR="/"
}

function helpCd () {
    echo "Create a new directory at the specified path.

    #> connect
    > cd path"
}
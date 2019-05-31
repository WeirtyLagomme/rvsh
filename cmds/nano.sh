#!/bin/bash

function nano () {
    # Set locals
    local lookup="$1"
    # Set local path
    local path=$(buildPath "$lookup" "true")
    # Error handler
    [[ $(cut -d ' ' -f1 <<< "$path") == "dispError" ]] && eval $path && return 1
    # File should exist
    [[ ! -f "$path" ]] && dispError "2" "Incorrect path to edit" && return 1
    # Start edit
    command nano "$path"
}

function helpNano () {
    echo "Small file editor.

    #> connect
    > nano path"
}
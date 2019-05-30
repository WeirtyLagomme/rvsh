#!/bin/bash

function rm () {
    # Set locals
    local lookup="$1"
    # Set local path
    local path=$(buildPath "$lookup" "true")
    # Error handler
    [[ $(cut -d ' ' -f1 <<< "$path") == "dispError" ]] && eval $path && return 1
    # Path must be at lower level than root
    if [[ ! $path =~ ^"./vms/$SESSION_VM/root/".{1,}$ ]]; then
        dispError "2" "You can't remove anything above the root level" && return 1
    fi
    # Remove file
    command rm -rf "$path"
    dispNotif "2" "Document successfuly removed"
}

function helpRm () {
    echo "Remove a file or a directory.
    
    #> connect
    > rm path"
}
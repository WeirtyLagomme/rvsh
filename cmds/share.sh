#!/bin/bash

# $1 : user
# $2 : vm
# $3 : path
function share () {
    # Set locals
    local user="$1"
    local vm="$2"
    local lookup="$3"
    # Set local path
    local path=$(buildPath "$lookup" "true")
    # Error handler
    [[ $(cut -d ' ' -f1 <<< "$path") == "dispError" ]] && eval $path && return 1
    # Share file
    local destination="./vms/$vm/root/$user/share/$SESSION_USER"
    command mkdir -p $destination && command cp -R "$path" $destination
    # Display success notification
    dispNotif "2" "Document(s) have been successfuly shared with $user"
}

function helpShare () {
    echo "Small file editor.

    #> connect
    > share username{file:usr} vm_name{file:vm} path"
}
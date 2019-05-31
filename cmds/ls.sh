#!/bin/bash

# $1 : lookup
function ls () {
    # Set locals
    local lookup="$1"
    # Set local path
    local path=$(buildPath "$lookup" "true")
    # Error handler
    [[ $(cut -d ' ' -f1 <<< "$path") == "dispError" ]] && eval $path && return 1
    # Should be a file
    [[ -f "$path" ]] && dispError "2" "Incorrect path to list" && return 1
    # Format result
    local list=$(command ls "$path")
    # Empty directory
    [[ -z $list ]] && dispNotif "2" "Current directory is empty" && return 0
    # Display result
    local tmp=($(tr "\n" " " <<< "$list"))
    local res=""
    for el in "${tmp[@]}"; do 
        [[ -d "$path/$el" ]] && res+="${BL}$el${NC}/"
        [[ -f "$path/$el" ]] && res+="$el"
        res+="  "
    done
    echo -e "\n  $res"
}

function helpLs () {
    echo "List all files and directories in the current directory.

    #> connect
    > ls [path]"
}
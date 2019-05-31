#!/bin/bash

function cat () {
    # Set locals
    local lookup="$1"
    # Set local path
    local path=$(buildPath "$lookup" "true")
    # Error handler
    [[ $(cut -d ' ' -f1 <<< "$path") == "dispError" ]] && eval $path && return 1
    # Should be a file
    [[ ! -f "$path" ]] && dispError "2" "Incorrect path to display" && return 1
    # Error handler
    local res=$(command cat "$path" 2> /dev/null || echo "error")
    [[ $res == "res" ]] && dispError "2" "Incorrect path : ${OR}$lookup${NC}" && return 1
    # Display success notification
    local file_name=$(basename "$path")
    echo -e "\n [${BL}${file_name^}'s content${NC}]\n\n$(sed 's/^/ /g'<<< $res)"
}

function helpCat () {
    echo "Display file's content.

    #> connect
    > cat path"
}
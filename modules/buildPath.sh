#!/bin/bash

# $1 : lookup
# $2 : exists
function buildPath () {
    # Set locals
    local lookup="$1"
    local exists="$2"
    # Root path
    local root="./vms/$SESSION_VM/root"
    local path="$root"
    # Absolute path
    if [[ $lookup =~ ^"/" ]]; then path+="$lookup"
    else 
        [[ $lookup =~ ^"./" ]] && lookup=${lookup:2}
        path+="$SESSION_DIR/$lookup"
    fi
    # Out of bonds path
    [[ -z $(command realpath "$path" | grep ^.*"${root//"/"/"\/"}") ]] && echo "$root/" && return 0
    # Reformat path
    path="$root$(command realpath "$path" | sed 's/^.*'"${root//"/"/"\/"}"'//')"
    # Check path
    local path_exists=$(command ls "$path" 2> /dev/null || echo "error")
    if [[ $exists == "true" ]] && [[ $path_exists == "error" ]]; then
        echo "dispError \"2\" \"Incorrect path : ${OR}${path#$root}${NC}\"" && return 1
    fi
    # Return path
    echo "$path"
}
#!/bin/bash

# $1 : str
function hash () {
    local str="$1"
    [[ -z $str ]] && dispError "42" "Empty string send to the hash function" && return 1
    echo "$(echo -n "$str" | sha256sum | cut -d ' ' -f1)"
}
#!/bin/bash

# $1 : filename
# $2 : file type
function fileExists () {
    local name="$1" && emptyVar "name" "$name" "42" || return 1
    local type="$2" && emptyVar "type" "$type" "42" || return 1
    echo "./${type}s/$name.$type"
    if [[ ! -e "./${type}s/$name.$type" ]]; then
        return 1
    fi
    return 0
}
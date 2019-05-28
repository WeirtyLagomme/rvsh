#!/bin/bash

# $1 : filename
# $2 : file type
# $3 : error type
# $4 : exists
function fileExists () {
    # Set locals
    local name="$1" && emptyVar "name" "$name" "42" || return 1
    local type="$2" && emptyVar "type" "$type" "42" || return 1
    local error="$3" && emptyVar "error" "$error" "42" || return 1
    local exists="$4" && emptyVar "exists" "$exists" "42" || return 1
    # Check values
    if [[ $exists != "true" ]] && [[ $exists != "false" ]]; then
        dispError "42" "Incorrect value for ${OR}exists${NC} in fileExists()" && return 1
    fi
    # Error message
    local subject="virtual machine "
    [[ $type == "usr" ]] && subject="user"
    local word="already"
    # Check file
    [[ $exists == "false" ]] && [[ ! -e "./${type}s/$name.$type" ]] && return 0
    [[ $exists == "true" ]] && word="doesn't" && [[ -e "./${type}s/$name.$type" ]] && return 0
    dispError "$error" "Incorrect ${subject}name : ${OR}$name${NC} $word exists" && return 1
}
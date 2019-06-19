#!/bin/bash

# $1 : bool
# $2 : type
# $3 : name
# $4 : error
function entityExists () {
    # Set locals
    local bool="$1" && emptyVar "bool" "$bool" "42" || return 1
    local type="$2" && emptyVar "type" "$type" "42" || return 1
    local name="$3" && emptyVar "name" "$name" "42" || return 1
    local error="$4" && emptyVar "error" "$error" "42" || return 1
    # Check type value and set entity
    local entity
    if [[ $type == "usr" ]]; then entity="user"
    elif [[ $type == "vm" ]]; then entity="virtual machine "
    else 
        dispError "42" "Incorrect entity ${OR}type${NC} received in entityExists()" && return 1 
    fi
    # Check bool value
    if [[ $bool != "true" ]] && [[ $bool != "false" ]]; then
        dispError "42" "Incorrect value for ${OR}exists${NC} in fileExists()" && return 1
    fi
    # Entity status matches bool ?
    local word="already"
    [[ $bool == "false" ]] && [[ ! -d "./${type}s/$name" ]] && return 0
    [[ $bool == "true" ]] && word="doesn't" && [[ -d "./${type}s/$name" ]] && return 0
    # Entity status doesn't matches bool
    dispError "$error" "Incorrect ${entity}name : ${OR}$name${NC} $word exist" && return 1
}
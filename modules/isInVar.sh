#!/bin/bash

# $1 : content
# $2 : file
# $3 : var_name
# $4 : error_type
# $5 : error_msg
function isInVar () {
    # Set locals
    local content="$1" && emptyVar "content" "$content" "42" || return 1
    local file="$2" && emptyVar "file" "$file" "42" || return 1
    local var_name="$3" && emptyVar "var_name" "$var_name" "42" || return 1
    # Get var's content
    local var_content=$(getVar "$file" "$var_name")
    [[ ! $var_content =~ (^|[[:space:]])$content($|[[:space:]]) ]] && return 1
    return 0
}
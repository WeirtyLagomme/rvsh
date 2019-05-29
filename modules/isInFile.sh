#!/bin/bash

# $1 : file
# $2 : content
function isInFile () {
    # Set locals
    local file="$1" && emptyVar "file" "$file" "42" || return 1
    local content="$2" && emptyVar "content" "$content" "42" || return 1
    # Match file content
    [[ -z $(grep '^'"$content"'$' "$file") ]] && return 1
    return 0
}
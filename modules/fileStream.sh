#!/bin/bash

# $1 : stream
# $2 : file
# $3 : content
# $4 : new content
function fileStream () {
    # Set locals
    local stream="$1" && emptyVar "stream" "$stream" "42" || return 1
    local file="$2" && emptyVar "file" "$file" "42" || return 1
    local content="$3" && emptyVar "content" "$content" "42" || return 1
    local new_content="$4"
    if [[ -z $new_content ]] && [[ $stream == "replace" ]]; then
        dispError "42" "Missing ${OR}new_content${NC} in fileStream()"
        return 1
    fi
    # Select stream type
    case $stream in
        append ) echo "$content" >> "$file" ;;
        replace ) sed -i 's/^'"$content"'$/'"$new_content"'/' "$file" ;;
        remove ) sed -i '/^'"$content"'$/d' "$file" ;;
        * ) dispError "42" "Incorrect ${OR}stream type${NC} received in fileStream()" ;;
    esac
}
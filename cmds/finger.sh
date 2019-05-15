#!/bin/bash

# $1 : properties
function finger () {
    local properties=( "$@" )
    local content
    # Asked properties
    if [[ ! -z $properties ]]; then
        # Read properties
        for prop in "${properties[@]}"; do
            local prop_value="$(getVar "./usrs/$SESSION_USER.usr" "info_$prop")"
            # All properties must exist
            [[ -z $prop_value ]] && dispError "3" "The property \"$prop\" doesn't exists" && return 1
            content+="\n\n ${OR}::${NC} $prop ${DI}>${NC} $prop_value"
        done
    else # All properties
        local props_lines="$(sed -n -e '/^info_/p' "./usrs/toto.usr")"
        content="\n${props_lines//"info_"/\\n ${OR}::${NC} }"
        content="${content//=/" ${DI}>${NC} "}"
        content="${content//\"}"
    fi
    # Print properties
    echo -e "\n [${CY}Properties${NC}] $content"
}

function helpFinger () {
    echo "Get complementary information about the current user
    
    > finger [property_name...]"
}
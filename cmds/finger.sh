#!/bin/bash

# $1 : properties
function finger () {
    local properties=("$@")
    local content
    # Asked properties
    if [[ ! -z $properties ]]; then
        # Read properties
        for prop in "${properties[@]}"; do
            local prop_value="$(getVar "./usrs/$SESSION_USER.usr" "info_$prop")"
            # All properties must exist
            [[ -z $prop_value ]] && dispNotif "1" "The property \"$prop\" doesn't exists" && continue
            content+="\n\n ${OR}::${NC} $prop ${DI}>${NC} $prop_value"
        done
    else # All properties
        local props_lines=$(sed -n -e '/^info_/p' "./usrs/$SESSION_USER.usr")
        # No properties
        [[ -z $props_lines ]] && dispNotif "2" "No information available" && return 1
        content="\n${props_lines//"info_"/\\n ${OR}::${NC} }"
        content="${content//=/" ${DI}>${NC} "}"
        content="${content//\"}"
    fi
    # Print properties
    [[ -z $content ]] && content="\n\n No information available"
    echo -e "\n [${CY}Properties${NC}] $content"
}

function helpFinger () {
    echo "Get complementary information about the current user.
    
    > finger [property_name...]"
}
#!/bin/bash

# $1 : var name
# $2 : file
# $3 : set mode
# $4 : var value
function setVar () {
    # Name can't be empty
    local name="$1"
    if [[ -z $name ]]; then
        dispError "42" "Var name received in setVar() was empty"
        return 1
    fi
    # File can't be empty
    local file="$2"
    if [[ -z $file ]]; then
        dispError "42" "File received in setVar() was empty"
        return 1
    fi
    # Set mode can't be empty
    local mode="$3"
    if [[ -z $mode ]]; then
        dispError "42" "Set mode received in setVar() was empty"
        return 1
    fi
    local value="$4"
    # Value can't be empty in some modes
    if [[ $mode != "empty" && -z $value ]]; then
        dispError "42" "Value received in setVar() was empty"
        return 1
    fi
    # Translate mode
    case $mode in
        "push" )
            sed -i 's/^'"$name"'="/&'"$value"'/' "$file"
            ;;
        "replace" )
            sed -i 's/^'"$name"'=".*"$/'"$name"'="'"$value"'"/' "$file"
            ;;
        "empty" )
            sed -i 's/^'"$name"'=".*"$/'"$name"'=""/' "$file"
            ;;
        "pop" )
            local fullVar=$(getVar "$file" "$name")
            sed -i 's/^'"$name"'=".*"$/'"$name"'="'"${fullVar/$value}"'"/' "$file"
            ;;
        * )
            dispError "42" "Set mode received by setVar() was incorrect"
            ;;
    esac
}
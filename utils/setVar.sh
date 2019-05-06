#!/bin/bash

# $1 : var name
# $2 : var value
# $3 : file
# $4 : set mode
function setVar () {
    # Var name can't be empty
    local name="$1"
    if [[ -z $name ]]; then
        dispError "42" "Var name received in setVar() was empty"
        return 1
    fi
    # Var value can't be empty
    local value="$2"
    if [[ -z $value ]]; then
        dispError "42" "Var value received in setVar() was empty"
        return 1
    fi
    # File can't be empty
    local file="$3"
    if [[ -z $file ]]; then
        dispError "42" "File received in setVar() was empty"
        return 1
    fi
    # Set mode can't be empty
    local mode="$4"
    if [[ -z $mode ]]; then
        dispError "42" "Set mode received in setVar() was empty"
        return 1
    fi
    # Translate mode
    if [[ $mode == "append" ]]; then
        sed -i 's/'"$name"'="/&'"$value"'/' "$file"
    elif [[ $mode == "replace" ]]; then
        sed -i 's/^'"$name"'=".*"$/password="'"$value"'"/' "$file"
    else
        dispError "42" "Set mode received by setVar() was incorrect"
        return 1
    fi
}
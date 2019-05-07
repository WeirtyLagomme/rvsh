#!/bin/bash

# $1 : var name
# $2 : var value
# $3 : file
# $4 : set mode
function setVar () {
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
    # Var name maybe can't be empty
    local name="$1"
    local err_name="Var name received in setVar() was empty"
    # Translate mode
    case $mode in
        "push" )
            [[ ! -z $name ]] && sed -i 's/'"$name"'="/&'"$value"'/' "$file" || dispError "42" "$err_name"

            ;;
        "replace" )
            [[ ! -z $name ]] && sed -i 's/^'"$name"'=".*"$/password="'"$value"'"/' "$file" || dispError "42" "$err_name"
            ;;
        "pop" )
            sed -e s/"$value"//g -i "$file"
            ;;
        * )
            dispError "42" "Set mode received by setVar() was incorrect"
            ;;
    esac
}
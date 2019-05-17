#!/bin/bash

# $1 : mode
# $2 : username
# $3 : properties
function afinger () {
    # Mode shouldn't be empty
    local mode="$1"
    [[ -z $mode ]] && dispError "3" "Missing argument : mode" && return 1 # DO A FUCKING VERSION IF THIS IN DISPERROR
    # Must be an available mode
    local method=$(getMethod $mode)
    [[ -z $method ]] && dispError "2" "The mode \"$mode\" doesn't exists" && return 1
    # Username shouldn't be empty
    local username="$2"
    [[ -z $username ]] && dispError "3" "Missing argument : username" && return 1
    # Properties shouldn't be empty
    local properties="$3"
    [[ -z $properties ]] && dispError "3" "Missing argument : properties" && return 1
    # Execute mode
    $method "${@:2}"
}

# $1 : username
# $2 : properties
function addAfinger () {
    local username="$1"
    local properties=("${@:2}")
    for property in "${properties[@]}"; do
        # Properties format
        if [[ ! $property =~ ^[A-Za-z0-9_]{1,}=([A-Za-z0-9_]{1,},?){1,} ]]; then
            dispError "3" "Wrong format for property : \"$property\"" && return 1
        fi
        # Split name & value
        local prop_name="$(echo "$property" | cut -d = -f1)"
        local prop_values="$(echo "$property" | cut -d = -f2)"
        # If property already exists just update it
        local action="create"
        local existing_property="$(getVar "./usrs/$username.usr" "info_$prop_name")"
        [[ ! -z $existing_property ]] && action="replace"
        # Array of values ?
        [[ $prop_values == *","* ]] && prop_values="(${prop_values//,/)(})"
        # Set new property
        setVar "info_$prop_name" "./usrs/$username.usr" "$action" "$prop_values"
    done
    dispNotif "1" "$username's properties have been successfuly added"
}

# $1 : username
# $2 : properties_names
function removeAfinger () {
    local username="$1"
    local properties_names=("${@:2}")
    for property_name in "${properties_names[@]}"; do
        # Property must exists
        local existing_property="$(getVar "./usrs/$username.usr" "info_$property_name")"
        [[ -z $existing_property ]] && dispError "3" "The property \"$property_name\" doesn't exists" && return 1
        # Remove property
        setVar "info_$property_name" "./usrs/$username.usr" "remove"
    done
    dispNotif "1" "$username's properties have been successfuly removed"
}

function helpAfinger () {
    echo "Add complementary information about any user
    
    #> admin
    > afinger property_name=property_value_1,property_value_2... [property_name=property_value_1,property_value_2...]"
}
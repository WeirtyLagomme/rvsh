#!/bin/bash

# $1 : username
# $2 : properties
function addAfinger () {
    local username="$1"
    local properties=(${@:2})
    for property in "${properties[@]}"; do
        # Properties format
        if [[ ! $property =~ ^[A-Za-z0-9_]{1,}=([A-Za-z0-9_]{1,},?){1,} ]]; then
            dispError "3" "Wrong format for property : \"$property\"" && return 1
        fi
        # Split name & value
        local prop_name=$(echo "$property" | cut -d = -f1)
        local prop_values=$(echo "$property" | cut -d = -f2)
        # If property already exists just update it
        local action="create"
        local existing_property=$(getVar "./usrs/$username.usr" "info_$prop_name")
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
    local properties_names=(${@:2})
    # Properties must exists
    for property_name in "${properties_names[@]}"; do
        local existing_property=$(getVar "./usrs/$username.usr" "info_$property_name")
        [[ -z $existing_property ]] && dispError "3" "The property \"$property_name\" doesn't exists" && return 1
    done
    # Remove properties
    for property_name in "${properties_names[@]}"; do
        setVar "info_$property_name" "./usrs/$username.usr" "remove"
    done
    dispNotif "1" "$username's properties have been successfuly removed"
}

function helpAfinger () {
    echo "Add complementary information about any user
    
    #> admin
    > afinger -add username property_name=property_value_1,property_value_2... [property_name=property_value_1,property_value_2...]
    > afinger -remove username property_name [property_name...]"
}
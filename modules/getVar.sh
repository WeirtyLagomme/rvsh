#!/bin/bash

# Get the required variable value from file
# $1 : file path
# $2 : variable name
function getVar () {
    # Set local variables
    local file="$1"
    local var="$2"
    # Check for errors before returning variable
    if [[ -z $file ]] || [[ -z $var ]]; then
        # Variables shouldn't be empty
        dispError "42" "Empty variables received in the \"getVar\" function"
    elif [[ ! -e $file ]]; then
        # File must exists
        dispError "42" "File provided in the \"getVar\" function doesn't exist"
    else
        # variable value
        local var_value=$(awk -F'"' '/^'"$var"'=/ {print $2}' $file)
        # Parse array
        [[ $var_value =~ ^\(.*\)$ ]] && var_value=$(sed -e 's/(//g' -e 's/)/ /g' <<< "$var_value")
        # Return value
        echo "$var_value"
    fi
}
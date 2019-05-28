#!/bin/bash

# Get the required variable value from file
# $1 : file path
# $2 : var_name
function getVar () {
    # Set local variables
    local file="$1" && emptyVar "file" "$file" "42" || return 1
    local var_name="$2" && emptyVar "var_name" "$var_name" "42" || return 1
    # File must exists
    [[ ! -e $file ]] && dispError "42" "File provided in the \"getVar\" function doesn't exist" && return 1
    # Variable value
    local var_value=$(awk -F'"' '/^'"$var_name"'=/ {print $2}' $file)
    # Parse array
    [[ $var_value =~ ^\(.*\)$ ]] && var_value=$(sed -e 's/(//g' -e 's/)/ /g' <<< "$var_value")
    # Return value
    echo "$var_value"
    
}
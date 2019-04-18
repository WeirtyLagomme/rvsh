#!/bin/bash

# Get the required variable value from file
# $1 : file path
# $2 : variable name
function getVar () {
    # Set local variables
    local file=$1
    local var=$2
    # Check for errors before returning variable
    if [ "$file" = "" ] || [ "$var" = "" ]; then
        # Variables shouldn't be empty
        dispError "42" "Empty variables received in the \"getVar\" function"
    elif [ ! -f "$file" ]; then
        # File must exists
        dispError "42" "File provided in the \"getVar\" function doesn't exist"
    else
        # Return variable value
        echo $(awk -F'"' '/^'"$var"'=/ {print $2}' $file)
    fi
}
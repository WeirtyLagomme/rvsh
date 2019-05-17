#!/bin/bash

# $1 : cmd
# $@:2 : args
function checkCmd () {
    local cmd="$1"
    local args="${@:2}"
    local infos=$(help${cmd^})
    # Specified conditions
    local cond_match
    checkUseConditions "$infos"
    [[ -z $cond_match ]] && return 1
    # Format
    checkFormat "$infos" "$args"
}

# Inherit: cmd, infos, args
function checkFormat () {
    # Command syntaxes : only required arguments
    local syntaxes=$(grep -o '[^#]> .*' <<< "$infos" | cut -d ' ' -f4- | cut -d "[" -f1 | sed -e 's/[[:space:]]*$//')
    # No arguments required
    [[ -z $syntaxes ]] && $cmd $args && return 0
    # No arguments provided
    [[ -z $args ]] && dispError "3" "No arguments provided" && return 1
    # Mode needed
    local mode
    if [[ $syntaxes =~ ^\-.*$ ]]; then
        # Mode format
        [[ ! $args =~ ^\-.*$ ]] && dispError "3" "Incorrect mode format, it should look like \"-mode\"" && return 1 
        # Must be an available mode
        local input_mode=$(cut -d ' ' -f1 <<< $args)
        method=$(getMethod $input_mode)
        [[ -z $method ]] && dispError "2" "The mode \"$input_mode\" doesn't exists" && return 1
        mode=$input_mode
    fi
    # Select syntax
    local syntax=$syntaxes
    [[ ! -z $mode ]] && syntax=$(grep -o '^'"$mode"'.*' <<< "$syntaxes" | cut -d ' ' -f2-)
    # Missing nth argument
    local args_count=$(( $(wc -w <<< "$args") - 1 ))
    if (( $(wc -w <<< $syntax) > $args_count )); then
        local missing_arg=$(cut -d ' ' -f $(($args_count + 1)) <<< $syntax)
        dispError "3" "Missing argument : $missing_arg"
        return 1
    fi
    # Execute command
    local cmd=$cmd
    local args=$args
    [[ ! -z $mode ]] && cmd=$method && args=$(cut -d ' ' -f2- <<< $args)
    $cmd $args
}

function checkUseConditions () {
    if [[ $infos =~ (\#\> .*) ]]; then
        local infos_cond=$(grep -o '#> .*' <<< "$infos")
        infos_cond=${infos_cond//\#> }
        local conditions=($infos_cond)
        for cond in "${conditions[@]}"; do
            if [[ $SESSION_MODE != "$cond" ]]; then
                dispError "4" "You must be in \"$cond\" mode in order to use this command"
                return 1
            fi
        done
    fi
    # Conditions matched
    cond_match="true"
}
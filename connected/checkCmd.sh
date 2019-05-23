#!/bin/bash

# $1 : cmd
# $@:2 : args
function checkCmd () {
    local cmd="$1"
    local args="${@:2}"
    local infos=$(help${cmd^})
    # Must be an available command
    [[ ! -e "./cmds/$cmd.sh" ]] && dispError "2" "The command ${OR}$cmd${NC} doesn't exists" && return 1
    # Specified conditions
    checkUseConditions "$infos" || return 1
    # Format
    checkFormat "$infos" "$args"
}

# Inherit: cmd, infos, args
function checkFormat () {
    # Command syntaxes : only required arguments
    local syntaxes=$(grep -o '[^#]> .*' <<< "$infos" | cut -d ' ' -f4- | cut -d "[" -f1 | sed -e 's/[[:space:]]*$//')
    # No arguments required
    if [[ -z $syntaxes ]]; then
        $cmd $args
        return 0
    fi
    # No arguments provided
    [[ -z $args ]] && dispError "3" "No arguments provided" && return 1
    # Mode needed
    local mode
    if [[ $syntaxes =~ ^\-.*$ ]]; then
        # Mode format
        [[ ! $args =~ ^\-.*$ ]] && dispError "3" "Incorrect mode format, it should look like \"-mode\"" && return 1 
        # Must be an available mode
        local input_mode=$(cut -d ' ' -f1 <<< "$args")
        method=$(getMethod $input_mode)
        [[ -z $method ]] && dispError "2" "The mode ${OR}$input_mode${NC} doesn't exists" && return 1
        mode=$input_mode
    fi
    # Select syntax
    local syntax=$syntaxes
    # Remove mode from syntax
    if [[ ! -z $mode ]]; then
        syntax=$(grep -o '^'"$mode"'.*' <<< "$syntaxes" | cut -d ' ' -f2-)
        [[ $syntax == $mode ]] && syntax=""
    fi
    # Missing nth argument
    local args_count=$(( $(wc -w <<< "$args") ))
    # Don't count mode
    [[ ! -z $mode ]] && args_count=$(( $args_count - 1 ))
    if (( $(wc -w <<< $syntax) > $args_count )); then
        local missing_arg=$(cut -d ' ' -f $(( $args_count + 1 )) <<< "$syntax")
        # Remove argument's conditions
        missing_arg=$(sed 's/{[^}]*}//g' <<< "$missing_arg")
        dispError "3" "Missing argument : ${OR}$missing_arg${NC}" && return 1
    fi
    # Arguments conditions
    if [[ $syntax =~ [A-Za-z0-9_]*\{.*\} ]]; then
        local args_split=($args)
        [[ ! -z $mode ]] && args_split=($(cut -d ' ' -f2- <<< "$args"))
        local syntax_split=($syntax)
        local rematches=(${BASH_REMATCH[@]})
        local rematch="0"
        # Which argument needs conditions ? 
        for i in "${!syntax_split[@]}"; do
            # Split conditions
            if [[ ${syntax_split[$i]} == ${rematches[$rematch]} ]]; then
                local arg_value="${args_split[$i]}"
                local arg_name=$(cut -d '{' -f1 <<< "${syntax_split[$i]}")
                local arg_conds=($(cut -d '{' -f2 <<< "${syntax_split[$i]}" | sed -e 's/}//' -e "s/,/ /g"))
                # Check conditions
                for cond in "${arg_conds[@]}"; do
                    local cond_name=$(cut -d ':' -f1 <<< "$cond")
                    local cond_value=$(cut -d ':' -f2 <<< "$cond")
                    # Min length
                    if [[ $cond_name == "min" ]]; then
                        if (( ${#arg_value} < $cond_value )); then
                            dispError "3" "The ${OR}$arg_name${NC} value must have a minimum length of 3"
                            return 1
                        fi
                    fi
                    # Format
                    if [[ $cond_name == "format" ]]; then
                        if [[ $cond_value == "norm" ]]; then
                            if [[ ! $arg_value =~ ^[A-Za-z0-9_]*$ ]]; then
                                dispError "3" "The ${OR}$arg_name${NC} format only accepts the following characters : [A-Za-z0-9_]"
                                return 1
                            fi
                        else
                            dispError "42" "Incorrect format type condition in ${OR}$arg_name${NC}"
                            return 1
                        fi
                    fi
                    # File existence
                    if [[ $cond_name == "file" ]]; then
                        if [[ $cond_value =~ ^"!"?("usr"|"vm")$ ]]; then
                            local should_exists="true"
                            [[ $cond_value =~ ^"!" ]] && should_exists="false" && cond_value=${cond_value//!}
                            fileExists "$arg_value" "$cond_value" "3" "$should_exists" || return 1
                        else
                            dispError "42" "Incorrect format for file condition in ${OR}$arg_name${NC}"
                            return 1
                        fi
                    fi
                done
                rematch=$(( $rematch + 1 ))
            fi
        done
        return 1
    fi
    echo "no special" && return 1
    # Execute command
    local cmd=$cmd
    local args=$args
    [[ ! -z $mode ]] && cmd=$method && args=$(cut -d ' ' -f2- <<< $args)
    $cmd $args
}

# $1 : infos
function checkUseConditions () {
    local infos="$1"
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
}
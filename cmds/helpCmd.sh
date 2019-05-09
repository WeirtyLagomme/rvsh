#!/bin/bash


# $1 : cmd_name
function helpCmd () {
    local cmd_name="$1"
    local arrow="${OR}->${NC}"
    if [[ -z $cmd_name ]]; then
        echo -e "\n [${GR}Help${NC}] Available commands :"
        for cmd in ./cmds/*.sh; do
            cmd_name=$(basename $cmd | cut -d. -f1)
            if [[ $cmd_name != "helpCmd" ]]; then
                local help_content="$(help${cmd_name^})"
                echo -e "\n [${CY}$cmd_name${NC}]\n${help_content//>/$arrow}"
            fi
        done
    elif [[ -e "./cmds/$cmd_name.sh" ]]; then  
        echo -e "\n [${GR}Help${NC}] The $cmd_name command"
        local help_content="$(help${cmd_name^})"
        echo -e "\n [${CY}$cmd_name${NC}]\n${help_content//>/$arrow}"
    else
        dispError "3" "The \"$cmd_name\" command doesn't exists"
    fi
}
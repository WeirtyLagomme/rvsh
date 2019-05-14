#!/bin/bash

# $1 : cmd_name
function help () {
    local cmd_name="$1"
    local arrow="${GR}->${NC}"
    if [[ -z $cmd_name ]]; then
        echo -e "\n [${GR}Help${NC}] All available commands for ${BL}users${NC} and ${OR}admins${NC}"
        for cmd in ./cmds/*.sh; do
            cmd_name=$(basename $cmd | cut -d. -f1)
            local help_content="$(help${cmd_name^})"
            local color="${BL}"
            if [[ "$(type -t need${cmd_name^})" == "function" ]]; then
                local need_cmd="$(need${cmd_name^})"
                [[ $need_cmd == *"admin"* ]] && color="${OR}"
            fi
            echo -e "\n [$color$cmd_name${NC}] ${help_content//>/$arrow}"
        done
    elif [[ -e "./cmds/$cmd_name.sh" ]]; then  
        local help_content="$(help${cmd_name^})"
        local color="${BL}"
        [[ $help_content == *"[ADMIN-ONLY]"* ]] && color="${OR}" && help_content=${help_content//"[ADMIN-ONLY]"}
        echo -e "\n [$color$cmd_name${NC}] ${help_content//>/$arrow}"
    else
        dispError "3" "The \"$cmd_name\" command doesn't exists"
    fi
}

function helpHelp () {
    echo "Gives information about how to use any commands or a specific one
    
    > help [command_name]"
}
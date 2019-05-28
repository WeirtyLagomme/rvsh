#!/bin/bash

# $1 : cmd
function help () {
    local cmd="$1"
    local arrow="${GR}->${NC}"
    local content=""
    if [[ -z $cmd ]]; then
        echo -e "\n [${GR}Help${NC}] All available commands for ${BL}all users${NC}, ${MA}connect mode${NC} and ${OR}admin mode${NC}"
        for cmd in ./cmds/*.sh; do
            cmd=$(basename $cmd | cut -d. -f1)
            local help_content=$(help${cmd^})
            local color="${BL}"
            [[ ! -z $(grep '#>.*admin.*' <<< "$help_content") ]] && color="${OR}"
            [[ ! -z $(grep '#>.*connect.*' <<< "$help_content") ]] && color="${MA}"
            # Remove conditions infos & argument's conditions
            help_content=$(sed '/#>.*$/d' <<< "$help_content" | sed -e 's/{[^}]*}//g' -e 's/[[:space:]]*$//')
            echo -e "\n [$color$cmd${NC}] ${help_content//>/$arrow}"
        done
    elif [[ -e "./cmds/$cmd.sh" ]]; then  
        local help_content=$(help${cmd^})
        local color="${BL}"
        [[ ! -z $(grep '#>.*admin.*' <<< "$help_content") ]] && color="${OR}"
        [[ ! -z $(grep '#>.*connect.*' <<< "$help_content") ]] && color="${MA}"
        # Remove conditions infos & argument's conditions
        help_content=$(sed '/#>.*$/d' <<< "$help_content" | sed 's/{[^}]*}//g')
        echo -e "\n [$color$cmd${NC}] ${help_content//>/$arrow}"
    else
        dispError "3" "The ${OR}$cmd${NC} command doesn't exists"
    fi
}

function helpHelp () {
    echo "Gives information about how to use any commands or a specific one
    
    > help [command_name]"
}
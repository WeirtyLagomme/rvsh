#!/bin/bash

# $1 : cmd
function help () {
    # Set locals
    local cmd="$1"
    local arrow="${GR}->${NC}"
    local content=""
    # Help all commands or a single one
    if [[ -z $cmd ]]; then
        # Display header
        printf "\n [${GR}Help${NC}] All available commands for ${BL}all users${NC}, ${MA}connect mode${NC} and ${OR}admin mode${NC}\n\n"
        # Store helps
        local helps=""
        # Manage loading bar
        local count=0
        local total=$(command ls -A ./cmds | wc -l)
        local pstr="[=======================================================================]"
        # Load helps
        for cmd in ./cmds/*.sh; do
            # Update loading bar
            count=$(( $count + 1 ))
            pd=$(( $count * 73 / $total ))
            printf "\r > Loading ${BL}%3d.%1d%%${NC} ${DI}%.${pd}s${NC}" $(( $count * 100 / $total )) $(( ($count * 1000 / $total) % 10 )) $pstr
            # Get help content
            cmd=$(basename $cmd | cut -d. -f1)
            local help_content=$(help${cmd^})
            # Set command color
            local color="${BL}"
            [[ ! -z $(grep '#>.*admin.*' <<< "$help_content") ]] && color="${OR}"
            [[ ! -z $(grep '#>.*connect.*' <<< "$help_content") ]] && color="${MA}"
            # Remove conditions infos & argument's conditions
            help_content=$(sed '/#>.*$/d' <<< "$help_content" | sed -e 's/{[^}]*}//g' -e 's/[[:space:]]*$//')
            # Store help
            helps+="\n [$color$cmd${NC}] ${help_content//>/$arrow}\n"
        done
        # Display helps
        printf "\n$helps"
    elif [[ -e "./cmds/$cmd.sh" ]]; then  
        # Get help content
        local help_content=$(help${cmd^})
        # Set command color
        local color="${BL}"
        [[ ! -z $(grep '#>.*admin.*' <<< "$help_content") ]] && color="${OR}"
        [[ ! -z $(grep '#>.*connect.*' <<< "$help_content") ]] && color="${MA}"
        # Remove conditions infos & argument's conditions
        help_content=$(sed '/#>.*$/d' <<< "$help_content" | sed 's/{[^}]*}//g')
        # Display help
        echo -e "\n [$color$cmd${NC}] ${help_content//>/$arrow}"
    else
        dispError "3" "The ${OR}$cmd${NC} command doesn't exists"
    fi
}

function helpHelp () {
    echo "Gives information about how to use any commands or a specific one
    
    > help [command_name]"
}
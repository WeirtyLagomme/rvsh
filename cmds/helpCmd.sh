
# $1 : cmd_name
function helpCmd () {
    local cmd_name="$1"
    if [[ -z $cmd_name ]]; then
        echo -e "\n [${GR}Help${NC}] Available commands :"
        for cmd in ./cmds/*.sh; do
            cmd_name=$(basename $cmd | cut -d. -f1)
            if [[ $cmd_name != "helpCmd" ]]; then
                local help_content="$(help${cmd_name^})"
                local arrow="${OR}->${NC}"
                echo -e "\n [${CY}$cmd_name${NC}]\n${help_content//>/$arrow}"
            fi
        done
    elif [[ -e "./cmds/$cmd_name.sh" ]]; then  
        echo -e "[${GR}Help${NC}] The $cmd_name command"
        echo -e "\n[${CY}$cmd_name${NC}]\n$(help${cmd_name^})"
    else
        dispError "3" "The \"$cmd_name\" doesn't exists"
    fi
}
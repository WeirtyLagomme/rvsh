#!/bin/bash

# $1 : username
function logs () {
    # Set locals
    local username="$1"
    # Display logs
    local content=$(sed -e $'s/^/ /g' < "./usrs/$username/logs")
    local content_length=$(wc -l <<< "$content")
    echo -e "\n [${CY}Logs of $username${NC}]"
    if (( $content_length > 15 )); then
        local line=1
        while (( $line < $content_length )); do
            local limit=$((line + 15))
            echo -e "\n ${DI}# Line $line to $limit${NC} \n"
            echo -e "$(sed $line,$limit!d <<< "$content")\n"
            echo -e " > Press ${OR}q${NC} to ${OR}exit${NC} or ${BL}n${NC} to ${BL}continue${NC}"
            while read -n1 -s log_action; do
                [[ $log_action == "q" ]] && return 0
                [[ $log_action != "n" ]] && continue
                line=$limit
                break
            done
        done
    else
        echo -e "\n$content"
    fi
}

function helpLogs () {
    echo "Display logs of specified user
    
    #> admin
    > logs username{file:usr}"
}
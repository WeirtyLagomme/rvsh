#!/bin/bash

function checkInbox () {
    local unread_msgs=$(getVar "./usrs/$SESSION_USER.usr" "unread_msgs")
    [[ -z $unread_msgs ]] && return 0
    displayMessages "$unread_msgs"
}

# $1 : unread_msgs
function displayMessages () {
    local unread_msgs="$1"
    echo -ne "\n\n [${OR}Message${NC}] You received new message(s)"
    # Split messages
    local msgs=($unread_msgs)
    for (( i=0; i<${#msgs[@]}; i++)); do
        local msg=${msgs[i]}
        local sender=$(cut -d, -f1 <<< "$msg")
        local content=${msg/$sender,}
        echo -ne "\n\n [${CY}$sender${NC}]\n\n $content"
        # Set prompt back
        echo -ne "\n$(buildPrompt)"
        # Send message to reads
        setVar "read_msgs" "./usrs/$SESSION_USER.usr" "push" "$unread_msgs"
        setVar "unread_msgs" "./usrs/$SESSION_USER.usr" "pop" "$unread_msgs"
    done
}
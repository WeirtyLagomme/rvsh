#!/bin/bash

function checkInbox () {
    [[ -s "./usrs/$SESSION_USER/msgs/unread" ]] && displayUnreadMessages || return 0
}


function displayUnreadMessages () {
    # Set file path
    local unread="./usrs/$SESSION_USER/msgs/unread"
    # Display command header
    echo -ne "\n\n [${OR}Message${NC}] You received $(wc -l $unread) new message(s)"
    # Format and display messages
    while read line; do
        # Split fields
        local date=$(cut -d ' ' -f1 <<< "$line")
        local sender=$(cut -d ' ' -f2 <<< "$line")
        local message=$(cut -d ' ' -f3- <<< "$line")
        # Display message
        echo -ne "\n\n [${BL}$sender${NC}] ${DI}$date${NC}\n\n $message"
    done < "$unread"
    # Transfer messages from unread to read and clear unread
    command cat "$unread" >> "./usrs/$SESSION_USER/msgs/read" && > "$unread"
    # Reset prompt
    echo -ne "\n$(buildPrompt)"
}
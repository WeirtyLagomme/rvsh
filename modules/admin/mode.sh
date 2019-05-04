#!/bin/bash

# Startup admin mode
function adminMode () {
    sed -i 's/connected_users="/&\('"$SESSION_USER"','"$SESSION_START"','"$SESSION_ID"'\)/' ./vms/flash.vm
    echo -ne "\n${CY}$SESSION_USER${NC}@${GR}rvsh${NC}>"
}
#!/bin/bash

# - - - - - < CONFIG > - - - - - #
# Colors
source ./config/colors.sh

# - - - - - < SESSION > - - - - - #
source ./sessions/session.sh

# Help
help () {
    echo -e "[${GR}Help${NC}] Available arguments :

        -c, -connect [vm_name, username]    Access a virtual machine through the connect mode.
        -a, -admin                          Login as admin in order to manage users and vms."
}

# Connect mode
# $2 : vm_name
# $3 : username
connectMode () {
    local vm_name="$2"
    local username="$3"
    # No empty values
    if [ $vm_name = "" ] || [ $username = "" ]; then
        echo -e "[${RE}Connection error${NC}] vm_name and username are required to connect. Use ${CY}nvsh -h${NC} for help."
    fi
    # Try to connect to vm
    connectVm $vm_name $username
}

# Find the corresponding vm and try to 
# $1 : vm_name
# $2 : username
connectVm () {
    local vm_name=$1
    local username=$2
    for vm in ./vms/*.vm; do
        local curr_vm_name=$(awk -F'"' '/^vm_name=/ {print $2}' $vm)
        local curr_auth_users=$(awk -F'"' '/^auth_users=/ {print $2}' $vm)
        if [ "$curr_vm_name" != $vm_name ]; then
            echo -e "[${RE}VM connection error${NC}] There's no vm named \"$vm_name\". Use ${CY}nvsh -h${NC} for help."
        elif [ "$curr_auth_user" != $username ]; then
            echo -e "[${RE}VM connection error${NC}] You're not authorized to connect to \"$vm_name\". Use ${CY}nvsh -h${NC} for help."
        else
            echo -ne "${CY}$username${NC}@${GR}$vm_name${NC} > "
            break
        fi
}

# Admin mode
adminMode () {
    # Logins
    local username password
    # Ask for logins
    echo -ne "[${OR}Admin mode${NC}] Admin login :"
    echo -ne "\nUsername:"
    read username
    echo -ne "Password:"
    read -s password
    # Try to login
    loginAdmin $username $password
}

# Try to find the user file and check logins
# $1 : username
# $2 : password
loginAdmin () {
    local username="$1"
    local password="$2"
    # Usernames and passwords can't have a length < 3
    if [ ${#username} -lt "3" ] || [ ${#password} -lt "3" ]; then
        echo -e "\n[${RE}Login error${NC}] Incorrect username or password."
        adminMode
    fi
    # Look for admin's user-file
    for usr in ./usrs/*.usr; do
        local curr_is_admin=$(awk -F'"' '/^admin=/ {print $2}' $usr)
        # Only check for admins
        if [ "$curr_is_admin" = "1" ]; then
            local curr_username=$(awk -F'"' '/^username=/ {print $2}' $usr)
            local curr_password=$(awk -F'"' '/^password=/ {print $2}' $usr)
            # TODO : faire les tests séparement pour savoir si c'est pass ou id qui fail
            if [ "$curr_username" = "$username" ] && [ "$curr_password" = "$password" ]; then
                sessionStart $username $curr_is_admin
            fi
        fi
    done
    # Is user logged in ?
    if [ "$SESSION_USER" = "" ]; then
        echo -e "[${RE}Login error${NC}] Incorrect username or password."
    fi
}

# Connection mode
case $1 in
    -c | -connect ) 
        connectMode $2 $3
        ;;
    -a | -admin )
        adminMode
        ;;
    -h | --help )
        help
        exit
        ;;
    * )
        error_type="Invalid"
        error_desc="\"$1\" doesn't exist"
        if [ "$1" = "" ]; then
            error_type="Missing"
            error_desc="You must specify in which mode you want to connect"
        fi
        echo -e "[${RE}$error_type argument${NC}] $error_desc. Use ${CY}nvsh -h${NC} for help."
        exit 127 # Invalid argument exit code
esac
#!/bin/bash

# - - - - - < CONFIG > - - - - - #
# Colors
source ./config/colors.sh

# - - - - - < UTILS > - - - - - #
# Display error
source ./utils/dispError.sh
# Get variable from file
source ./utils/getVar.sh

# - - - - - < SESSION > - - - - - #
source ./sessions/session.sh

# Help
function help () {
    echo -e "[${GR}Help${NC}] Available arguments :

        -c, -connect [vm_name, username]    Access a virtual machine through the connect mode.
        -a, -admin                          Login as admin in order to manage users and vms."
}

# Looking for a specific user by username
# $1 : username
#findUser () {
    #for user in ./usrs/*.usr; do

    #if [  ]
#}

# Connect mode
# $2 : vm_name
# $3 : username
function connectMode () {
    local vm_name=$1
    local username=$2
    # No empty values
    if [ "$vm_name" = "" ]; then
        dispError "1" "Missing option : \"vm_name\" is required to connect"
    elif [ "$username" = "" ]; then
        dispError "1" "Missing option : \"username\" is required to connect"
    else
        # Try to connect to vm
        connectVm "$vm_name" "$username"
    fi
}

# Find the corresponding vm and try to 
# $1 : vm_name
# $2 : username
function connectVm () {
    # Set local variables
    local vm_name=$1
    local username=$2
    # Loop through existing vms
    for vm in ./vms/*.vm; do
        # Current vm properties
        local curr_vm_name=$(getVar "$vm" "vm_name")
        local curr_auth_users=$(getVar "$vm" "auth_users")
        echo "auths: ${curr_auth_users[0]}"
        # Found corresponding vm
        if [ "$vm_name" = "$curr_vm_name" ]; then
            # User is authorized
            if [[ "${curr_auth_users[@]}" =~ "${username}" ]]; then
                echo -ne "${CY}$username${NC}@${GR}$vm_name${NC}>"
                return 0
            else
                dispError "1" "You're not authorized to connect to \"$vm_name\""
            fi
        else
            dispError "1" "There's no vm named \"$vm_name\""
        fi
    done
}

# Admin mode
function adminMode () {
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
function loginAdmin () {
    # Set local variables
    local username="$1"
    local password="$2"
    # Look for admin's user-file
    for usr in ./usrs/*.usr; do
        # Properties of current user-file
        local curr_username=$(getVar "$usr" "username")
        local curr_password=$(getVar "$usr" "password")
        local curr_is_admin=$(getVar "$usr" "admin")
        # Looking for matching username
        if [ "$username" = "$curr_username" ]; then
            # Check if password is correct
            if [ "$password" = "$curr_password" ]; then
                # User must be admin
                if [ "$curr_is_admin" = "1" ]; then
                    sessionStart $username $curr_is_admin
                else
                    echo "" # Last echo was -n
                    dispError "0" "You must be an administrator to use this mode"
                    adminMode
                fi
            else
                echo "" # Last echo was -n
                dispError "0" "Incorrect password"
                adminMode
            fi
            return 0
        fi
    done
    # Wrong username
    echo "" # Last echo was -n
    dispError "0" "Incorrect username"
    adminMode
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
    -t )
        dispError
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
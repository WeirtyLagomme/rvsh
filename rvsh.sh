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

# - - - - - < MODULES > - - - - - #
# Admin
source ./modules/admin/login.sh
# Connect
source ./modules/connect/login.sh

# Help
function help () {
    echo -e "[${GR}Help${NC}] Available arguments :

        -c, -connect [vm_name, username]    Access a virtual machine through the connect mode.
        -a, -admin                          Login as admin in order to manage users and vms."
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
        findUser "tom"
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
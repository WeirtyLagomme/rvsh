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
source ./modules/admin/mode.sh
# Connect
source ./modules/connect/login.sh
source ./modules/connect/mode.sh

# Help
function help () {
    echo -e "${CY} 
 >----------------------------------<
 |                        _         |
 |                       | |        |   ${NC}[${GR}Help${NC}] Available commands :${CY}
 |     _ __  __   __ ___ | |__      |
 |    | '_ \ \ \ / // __|| '_ \     |       ${NC}-c, -connect [vm_name, username]    Access a virtual machine through the connect mode.${CY}    
 |    | | | | \ V / \__ \| | | |    |      
 |    |_| |_|  \_/  |___/|_| |_|    |       ${NC}-a, -admin                          Login as admin in order to manage users and vms.${CY}
 |                                  |
 >----------------------------------<${NC}"
}

# Connection mode
case $1 in
    -c | -connect ) 
        connectModeLogin $2 $3
        ;;
    -a | -admin )
        adminModeLogin
        ;;
    -h | --help )
        help
        exit 0
        ;;
    -t )
        echo "test command"
        ;;
    * )
        error_type="Invalid"
        error_desc="\"$1\" doesn't exist"
        if [[ "$1" == "" ]]; then
            error_type="Missing"
            error_desc="You must specify in which mode you want to connect"
        fi
        echo -e "[${RE}$error_type argument${NC}] $error_desc. Use ${CY}nvsh -h${NC} for help."
        exit 127 # Invalid argument exit code
esac
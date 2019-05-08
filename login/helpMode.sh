#!/bin/bash

# Help
function helpMode () {
    echo -e "${CY} 
 >----------------------------------<
 |                        _         |
 |                       | |        |   ${NC}[${GR}Help${NC}] Available commands :${CY}
 |     _ __  __   __ ___ | |__      |
 |    | '_ \ \ \ / // __|| '_ \     |       ${NC}[ -c | -connect ] vm_name username    Access a virtual machine through the connect mode.${CY}    
 |    | | | | \ V / \__ \| | | |    |      
 |    |_| |_|  \_/  |___/|_| |_|    |       ${NC}[ -a | -admin ]                       Login as admin in order to manage users and vms.${CY}
 |                                  |
 >----------------------------------<${NC}"
}
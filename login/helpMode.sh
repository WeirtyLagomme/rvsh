#!/bin/bash

# Help
function helpMode () {
    echo -e "${CY} 
 >----------------------------------<
 |                        _         |
 |                       | |        |                 > Virtual network project <          
 |     _ __  __   __ ___ | |__      |
 |    | '_ \ \ \ / // __|| '_ \     |       Create, manage and use several virtual machines
 |    | | | | \ V / \__ \| | | |    |       
 |    |_| |_|  \_/  |___/|_| |_|    |            - Eleonore Desombre & Mickael Gomez -      
 |                                  |
 >----------------------------------<${NC}
 
 [${GR}Help${NC}] rvsh can be used in two modes :

    ( -c | -connect ) vm_name username    Access a virtual machine with a username through the connect mode.

    ( -a | -admin )                       Login as admin in order to manage users and virtual machines."
}
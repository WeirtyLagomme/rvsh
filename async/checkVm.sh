#!/bin/bash

function checkVm () {
    [[ $SESSION_MODE == "admin" ]] && return 0
    [[ -d  "./vms/$SESSION_VM" ]] && return 0
    dispNotif "0" "The virtual machine you were connected to has been deleted : ${OR}$SESSION_VM${NC}"
    exit 0
}
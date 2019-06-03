#!/bin/bash

# $1 : vm_from
# $2 : vm_to
function path () {
    # Set locals
    local vm_from="$1"
    local vm_to="$2"
    # Build graph
    local graph=""
    for vm in ./vms/*; do
        vm=$(basename "$vm")
        local links="./vms/$vm/links"
        [[ ! -s $links ]] && continue
        graph+=$(sed -e 's/^/'"$vm"',/' -e 's/$/,1/' $links)
        graph+="\n"
    done
    # VM to reach must be in graph
    [[ ! $graph =~ .*,$vm_to,.* ]] && dispNotif "2" "There's not path between $vm_from and $vm_to" && return 1
    # Solve shortest path
    graph+="solve,$vm_from,$vm_to"
    local path=$(printf "$graph" | awk -f ./modules/dijkstra.awk)
    # Diplay shortest path
    local format_path=$(cut -d ',' -f1,2 <<< "$path" | sed 's/^/ > /g')
    printf "\n [${BL}Shortest path to %s${NC}]\n\n%s\n" "$vm_to" "$format_path"
}

function helpPath () {
    printf "Looks for the shortest path between two virtual machines.
    
    #> connect
    > path vm_from{file:vm} vm_to{file:vm}"
}
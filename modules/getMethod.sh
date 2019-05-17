#!/bin/bash

# Inherit : $cmd
# $1 : mode
function getMethod () {
    local mode="$1"
    local method="${mode//-}${cmd^}"
    [[ "$(type -t $method)" == "function" ]] && echo "$method"
}
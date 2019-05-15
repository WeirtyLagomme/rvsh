#!/bin/bash

# Inherit : $cmd
# $1 : mode
function getMethod () {
    local method="${mode//-}${cmd^}"
    [[ "$(type -t $method)" == "function" ]] && echo "$method"
}
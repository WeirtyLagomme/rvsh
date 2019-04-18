#!/bin/bash

# Global session
SESSION_USER=""
SESSION_ADMIN=""
SESSION_START=""

# Start session
sessionStart () {
    SESSION_USER="$1"
    SESSION_ADMIN="$2"
    SESSION_START=$(date)
    echo -ne "${CY}$username${NC}@${GR}rvsh${NC} > "
}
#!/usr/bin/bash
# KL working commands 
clear

# Colors
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export BLUE='\033[0;34m'
export PURPLE='\033[0;35m'
export CYAN='\033[0;36m'
export WHITE='\033[0;37m'
export NC='\033[0m' # No Color

# Commands

h1() {
    echo -e "${CYAN}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
    echo -e "${PURPLE}$1${NC}"
    echo -e "${CYAN}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
}

# Using nc 
nc_1() {
    h1 "Using NC"
    DEST="45.79.112.203"
    PORT="4242"
    c1="${GREEN}nc ${DEST} ${PORT} ${NC}"
    echo -e "${GREENM}Executing ... ${c1}"
    eval "$c1"
}

# https://nmap.org/download.html#linux-rpm - Following this 
nc_in() {
    h1 "Installing NCAT"
}

# --- Execution --- 
nc_1

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

# --- Work Scripts --- 

# dig xbow.com
dig1()  {
    h1 "Dig xbow.com"
    c1="dig xbow.com"
    echo -e "${GREEN} Executing ... ${c1} ${NC}"
    eval "$c1"
}

# Detailed Manual HTTP responses 
curl1() {
    h1 "curl xbow.com"
    c1="curl -vvv xbow.com"
    echo -e "${GREEN} Executing ... ${c1} ${NC}"
    eval "$c1"
}

# Using NC to talk to servers
nc2() {
    h1 "Ncat to talk to server"
    c1="ncat $(dig +short xbow.com) 80"
    echo -e "${GREEN} Executing ... ${c1} ${NC}"
    eval "$c1"
}

# SubDomian Discovery 
sb1() {
    h1 "Subdomain Panty"
    
}

# --- Execution ---
# dig1 
# curl1
nc2
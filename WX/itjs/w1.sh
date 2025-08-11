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

# --- Start container --- 
ds1() {
    h1 "Start container"

    echo -e "${BLUE} List all containers ${NC}"
    c1="docker ps -a"
    echo -e "${BLUE} Executing ..${c1}"
    eval "$c1"

    echo -e "${BLUE} Start smell_panty container ${NC}"
    c2="docker start smell_panty"
    echo -e "${BLUE} Executing ..${c2}"
    eval "$c2"

    echo -e "${BLUE} Nose in her ass ${NC}"
    c3="docker exec -it smell_panty"
    echo -e "${BLUE} Executing ..${c3}"
    eval "$c3"

}

# Using nc 
nc_1() {
    h1 "Using NC"
    DEST="45.79.112.203"
    PORT="4242"
    c1="nc ${DEST} ${PORT}"
    echo -e "${GREEN}Executing ... ${c1}"
    eval "$c1"
}

# https://nmap.org/download.html#linux-rpm - Following this 
nc_in() {
    h1 "Installing NCAT"

    echo -e "${BLUE} First install Alien ${NC}"
    c1="sudo apt-get install alien"
    echo -e "${GREEN} Executing... ${c1} ${NC}"
    eval "$c1"

    echo -e "${BLUE} Download rpm - ncat-7.97-1.x86_64.rpm ${NC}"
    c2="wget ncat-7.97-1.x86_64.rpm"
    echo -e "${GREEN} Executing... ${c2} ${NC}"
    eval "$c2"

    echo -e "${BLUE} Download rpm - ncat-7.97-1.x86_64.rpm ${NC}"
    c3="sudo alien nmap-5.21-1.x86_64.rpm"
    echo -e "${GREEN} Executing... ${c3} ${NC}"
    eval "$c3"
}



# --- Execution --- 

# nc_1
# nc_in

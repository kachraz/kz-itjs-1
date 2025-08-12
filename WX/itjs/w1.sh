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
    echo -e "${GREEN} Executing ..${c1} ${NC}"
    eval "$c1"

    echo -e "${BLUE} Start smell_panty container ${NC}"
    c2="docker start smell_panty"
    echo -e "${GREEN} Executing ..${c2}${NC}"
    eval "$c2"

    echo -e "${MAGENTA} Nose in her ass ${NC}"
    c3="docker exec -it smell_panty zsh"
    echo -e "${GREEN} Executing ..${c3}${NC}"
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
    
    # Vars
    URL="https://nmap.org/dist/ncat-7.97-1.x86_64.rpm"
    F1="ncat-7.97-1.x86_64.rpm"
    F2="ncat_7.97-2_amd64.deb"

    # Install Alien
    echo -e "${YELLOW} ----------------------- ${NC}"
    echo -e "${BLUE} First install Alien ${NC}"
    c1="sudo apt-get install alien"
    echo -e "${GREEN} Executing... ${c1} ${NC}"
    eval "$c1"

    # Downlaod ncat 
    echo -e "${YELLOW} ----------------------- ${NC}"
    echo -e "${BLUE} Download ncat-7.97-1.x86_64.rpm ${NC}"
    c2="wget ${URL}"
    echo -e "${GREEN} Executing... ${c2} ${NC}"
    eval "$c2"

    # Convert to DEB 
    echo -e "${YELLOW} ----------------------- ${NC}"
    echo -e "${BLUE} Generate DEB ${NC}"
    c3="sudo alien ${F1}"
    echo -e "${GREEN} Executing... ${c3} ${NC}"
    eval "$c3"

    # Install DEB
    echo -e "${YELLOW} ----------------------- ${NC}"
    echo -e "${BLUE} Install deb ${NC}"
    c4="sudo dpkg --install ${F2}"
    echo -e "${GREEN} Executing... ${c4} ${NC}"
    eval "$c4"

    # Run version 
    ncat --version

    # Cleanup 
    echo -e "${YELLOW} ----------------------- ${NC}"
    c5="rm ${F1} ${F2}"
    echo -e "${BLUE} Cleanup ${NC}"
    echo -e "${GREEN} Executing... ${c1} ${NC}"
    eval "$c5"

}

# --- Various Workign test Commands 

# -- Nmap Related-- 

nmap_1() {
    h1 "Standard Namp Test against http://scanme.nmap.org/ "
    WB="scanme.nmap.org"
    c1="nmap -sS -sV -sC -A -T4 ${WB}"
    echo -e "${GREEN} Executing... ${c1} ${NC}"
    eval "$c1"
}


# --- Execution --- 
# ds1
# nc_1
# nc_in
# nc_in
nmap_1
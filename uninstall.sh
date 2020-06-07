#!/bin/bash

export BLUE='\033[1;94m'
export GREEN='\033[1;92m'
export RED='\033[1;91m'
export RESETCOLOR='\033[1;00m'

function check_root {
    if [ $(id -u) -ne 0 ]; then
        echo -e "\n$GREEN[$RED!$GREEN] $RED THIS SCRIPT MUST BE RUN AS ROOT!!!$RESETCOLOR\n" >&2
        sudo $0 $1
        exit 0
    fi
}

function config_all {
    systemctl stop tor
    systemctl disable tor
}
function remove_script_files {
    rm /usr/local/bin/tor-tunnel
    rm /usr/local/bin/checkip
}

check_root
echo -e "\n$BLUE Removing Files...$RESETCOLOR\n"
remove_script_files
echo -e "\n$BLUE Configuration Settings...$RESETCOLOR\n"
config_all
echo -e "\n$GREEN Uninstalled Successfully!!!$RESETCOLOR\n"
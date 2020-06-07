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
function copy_config_files {
    cp ./torrc /etc/tor/torrc
    cp ./tor.service /lib/systemd/system/tor.service
}
function config_all {
    system daemon-reload
    systemctl enable tor
}
function copy_script_files {
    cp ./tor-tunnel /usr/local/bin/
    chmod 755  /usr/local/bin/tor-tunnel
    cp ./checkip /usr/local/bin/
    chmod 755 /usr/local/bin/checkip
    install -g 0 -o 0 -m 0644 ./man/tor-tunnel.1 /usr/share/man/man1/
    gzip /usr/share/man/man1/tor-tunnel.1
}
function install_pkg {
    if ! dpkg -l | grep -n " tor " > /dev/null; then
        echo -e "\n$GREEN[$RED!$GREEN] $RED Tor is not Installed!!!$RESETCOLOR\n"
        echo "Installing Tor:"
        apt install tor
    else
        echo -e "\n$GREEN Tor is Installed!!!$RESETCOLOR\n"
    fi
    if ! dpkg -l | grep -n " python3  " > /dev/null; then
        echo -e "\n$GREEN[$RED!$GREEN] $RED Python3 is not Installed!!!$RESETCOLOR\n"
        echo "Installing Python3:"
        apt install python3
    else
        echo -e "\n$GREEN Python3 is Installed!!!$RESETCOLOR\n"
    fi
}

check_root
echo -e "\n$BLUE Installing Packages:$RESETCOLOR\n"
install_pkg
echo -e "\n$BLUE Coping Config Files...$RESETCOLOR\n"
#copy_config_files
echo -e "\n$BLUE Installing Tor-Tunnel...$RESETCOLOR\n"
copy_script_files
echo -e "\n$BLUE Configuration Settings...$RESETCOLOR\n"
config_all
echo -e "\n$GREEN Installed Successfully!!!$RESETCOLOR\n"
#!/bin/bash

# Defining color codes for the shell script
CL="clear"
J="\e[1;33m"
R="\e[1;31m"
V="\e[1;32m"
C="\e[36m"
FC="\e[0m"

# Path to the config file
CONFIG=/boot/config.txt

# Function to take input from the user
function read_input() {
    echo -n -e "$1"
    read var
    echo $var
}

# Modifying graphics settings
function modify_graphics() {
    # Backing up original config file
    sudo cp $CONFIG{,.bak}
    # Commenting out lines relating to graphics settings in config file
    sudo sed -i.bak '/^dtoverlay=vc4-kms-v3d/s/^/#/' $CONFIG
    sudo sed -i.bak '/^dtoverlay=vc4-fkms-v3d/s/^/#/' $CONFIG
    sudo sed -i.bak 's/^gpu_mem=64/gpu_mem=256/' $CONFIG
}

# Configuring settings for dual screens
function secondary_screen_config() {
    if [[ $(read_input "Do you want to configure Raspberry for two screens? yes/no: ") == "yes" ]]; then
        sudo cp /media/pi/SCRIPT-PI4/60-dualscreen.conf /usr/share/X11/xorg.conf.d/60-dualscreen.conf
    fi
}

# Installing xFreeRDP
function install_xfreerdp() {
    sudo apt install freerdp2-x11 -y
}

# Configuring and generating the xFreeRDP connection script
function configure_server() {
    domain=$(read_input "Enter domain name: ")
    user=$(read_input "Enter login: ")
    mdp=$(read_input "Enter password: ")
    IP=$(read_input "Enter IP Adress: ")
    echo "xfreerdp /f /sec:rdp /d:$domain /u:$user /p:$mdp /drive:USB,/media/pi/ /sound:sys:alsa,format:1,quality:high /rfx /gfx /gfx-h264 /multitransport /network:auto -bitmap-cache -glyph-cache /gdi:hw -fonts /v:$IP /multimon:force" >> /home/pi/Desktop/Serveur.sh
    cd /home/pi/Desktop/
    chmod a+x Serveur.sh
}

# Run all the functions
function main() {
    $CL
    modify_graphics
    secondary_screen_config
    install_xfreerdp
    configure_server

    # Asking the user if they want to reboot the system
    if [[ $(read_input "Do you want to reboot? yes/no: ") == "yes" ]]; then
        sudo reboot -f
    fi

    $CL
}

# Starting the script
main
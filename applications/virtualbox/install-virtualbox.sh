#!/bin/bash

read -p "make sure to run this script as root (or with sudo)"
pacman -S virtualbox
modprobe vboxdrv
modprobe vboxnetadp
modprobe vboxnetflt

touch /etc/modules-load.d/virtualbox-modules.conf
echo "vboxdrv" >> /etc/modules-load.d/virtualbox-modules.conf
echo "vboxnetadp" >> /etc/modules-load.d/virtualbox-modules.conf
echo "vboxnetflt" >> /etc/modules-load.d/virtualbox-modules.conf

pacman -S virtualbox-guest-iso
yay -S virtualbox-ext-oracle

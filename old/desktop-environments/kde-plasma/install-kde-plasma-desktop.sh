#!/bin/bash

pacman -S --needed xorg sddm
pacman -S --needed plasma kde-applications

sudo systemctl enable sddm
sudo systemctl enable NetworkManager

read -p "Press Enter to edit the config of SDDM: Theme: Current=breeze"
sudo nano /usr/lib/sddm/sddm.conf.d/default.conf

#sudo systemctl reboot

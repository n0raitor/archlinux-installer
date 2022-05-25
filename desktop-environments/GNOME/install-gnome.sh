#!/bin/bash

sudo pacman -S --needed gnome gnome-extra gdm gnome-tweaks
sudo pacman -S gnome-software-packagekit-plugin
sudo systemctl enable gdm.service

gsettings set org.gnome.desktop.peripherals.touchpad click-method areas

if pacman -Qs $package > /dev/null ; then
    echo -n "Removing Package \"Synaptics\"..."
    sudo pacman -Rnsc xf86-input-synaptics > /dev/null
    echo "Done"
fi

yay -S chrome-gnome-shell
yay -S gnome-terminal-transparency  # Transparent Terminal settings are enabled

### Use the Gnome Shell Extension Website to install Extensions
#yay -S gnome-shell-extension-blur-my-shell  # Blur Effekt on Shell Menu
#yay -S gnome-shell-extension-caffeine-git
#yay -S gnome-shell-extension-screenshot-git
#yay -S gnome-shell-extension-sound-output-device-chooser
#yay -S gnome-shell-extension-tray-icons-reloaded
#yay -S gnome-shell-extension-dash-to-dock

# DEP:
#yay -S gnome-shell-extension-extended-gestures-git
#yay -S gnome-shell-extension-timepp-git
#yay -S gnome-shell-extension-activities-config
#yay -S gnome-shell-extension-transparent-osd-git
#yay -S gnome-shell-frippery  # Move Clock
#yay -S gnome-shell-extension-dynamic-panel-transparency-git
#yay -S gnome-shell-extension-cpufreq (git auch nicht)
#yay -S gnome-shell-extension-screenshotlocations (git auch nicht)
#yay -S gnome-shell-extension-shelltile-git

#!/bin/bash

sudo pacman -S --needed gnome gnome-extra gdm gnome-tweaks
sudo pacman -S gnome-software-packagekit-plugin
sudo systemctl enable gdm.service

gsettings set org.gnome.desktop.peripherals.touchpad click-method areas

yay -S gnome-terminal-transparency  # Transparent Terminal settings are enabled
yay -S gnome-shell-extension-blur-my-shell  # Blur Effekt on Shell Menu
yay -S gnome-shell-extension-cpufreq
yay -S gnome-shell-extension-dynamic-panel-transparency-git
yay -S gnome-shell-extension-caffeine-git
#yay -S gnome-shell-extension-espresso-git
yay -S gnome-shell-frippery  # Move Clock
yay -S gnome-shell-extension-transparent-osd-git
yay -S gnome-shell-extension-screenshot-git
yay -S gnome-shell-extension-screenshotlocations
#yay -S gnome-shell-extension-shelltile-git
yay -S gnome-shell-extension-activities-config
yay -S gnome-shell-extension-sound-output-device-chooser
yay -S gnome-shell-extension-tray-icons-reloaded
yay -S gnome-shell-extension-timepp-git
yay -S gnome-shell-extension-dash-to-dock

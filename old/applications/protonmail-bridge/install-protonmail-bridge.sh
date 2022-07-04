#!/bin/bash

sudo pacman -S --needed gnome-keyring  # Required Dependency, otherwise Login will fail

yay -S protonmail-bridge-bin

echo "Visit https://protonmail.com/support/knowledge-base/protonmail-bridge-clients-windows-thunderbird/ for config informations"

#!/bin/bash

pacman -S ghidra

cp ghidra.ico /home/$USER/.local/share/icons/
cp ghidra.desktop /home/$USER/.local/share/applications/

chmod +x /home/$USER/.local/share/icons/ghidra.ico
chmod +x /home/$USER/.local/share/applications/ghidra.desktop

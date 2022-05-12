#!/bin/bash

pacman -S ghidra

mkdir /home/$USER/.local/share/ghidra
cp GHIDRA.svg /home/$USER/.local/share/ghidra/
cp ghidra.desktop /home/$USER/.local/share/applications/

chmod 644 /home/$USER/.local/share/icons/ghidra/GHIDRA.svg
chmod 744 /home/$USER/.local/share/applications/ghidra.desktop

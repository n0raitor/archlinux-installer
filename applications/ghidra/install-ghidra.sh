#!/bin/bash

pacman -S ghidra

# Prepare Ghidra
mkdir -p ~/.local/share/ghidra
cp ../resources/ghidra/GHIDRA.svg ~/.local/share/ghidra/
cp ../resources/ghidra/ghidra.desktop ~/.local/share/applications/
chown $USER ~/.local/share/ghidra/GHIDRA.svg
chown $USER ~/.local/share/applications/ghidra.desktop
sudo chgrp users ~/.local/share/ghidra/GHIDRA.svg
sudo chgrp users ~/.local/share/applications/ghidra.desktop
chmod 644 ~/.local/share/ghidra/GHIDRA.svg
chmod 744 ~/.local/share/applications/ghidra.desktop

#!/bin/bash

sudo pacman -S libreoffice-still libreoffice-still-de  # stable version (newer features in "fresh")

### office language ads
sudo pacman -S hunspell-en hunspell-de mythes-en mythes-de aspell-en aspell-de languagetool enchant 
yay -S libreoffice-extension-languagetool 
sudo pacman -S libmythes 

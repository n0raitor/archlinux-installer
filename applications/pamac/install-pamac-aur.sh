#!/bin/bash

pacman -S appstream-glib
yay -S archlinux-appstream-data-pamac
yay -S pamac-aur

# If "Missing Dependency: pamac-aur-git"
yay -S libpamac-aur

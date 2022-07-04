#!/bin/bash

git clone https://aur.archlinux.org/snapd.git
$ cd snapd
$ makepkg -si
cd ..
rm -rf snapd

systemctl enable --now snapd.socket

# ln -s /var/lib/snapd/snap /snap  # Classic Snap Support


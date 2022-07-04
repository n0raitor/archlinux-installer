#!/bin/bash

pacman -S cups ghostscript cups-pdf hplip


systemctl enable cups
systemctl start cups
pacman -S system-config-printer

yay -S brother-dcpj315w

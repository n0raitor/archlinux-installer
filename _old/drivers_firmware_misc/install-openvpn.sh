#!/bin/bash
pacman -S openvpn networkmanager-openvpn
systemctl restart NetworkManager

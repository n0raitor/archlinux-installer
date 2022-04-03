#!/bin/bash

pacman -S acpid dbus avahi

systemctl enable acpid
systemctl enable avahi-daemon

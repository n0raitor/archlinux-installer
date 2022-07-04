#!/bin/bash

pacman -S flatpak

# integriert das Flathub Repositorium, das eine zentrale Sammelstelle für flatpaks darstellt.
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

#!/bin/bash

function join { local IFS="$1"; shift; echo "$*"; }

# Import Key For 1Password
curl -sS https://downloads.1password.com/linux/keys/1password.asc | gpg --import

# Import Key For Spotify
curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | gpg --import -

# Set NumKey Enabled
gsettings set org.gnome.desktop.peripherals.keyboard numlock-state true

pacman_packages=( telegram-desktop tlp tlp-rdw brave-browser gnome-games lutris dia vim vim-spell-de vim-spell-en ghex darktable scribus openshot appimagelauncher yay nautilus-terminal arc-gtk-theme arc-icon-theme cantarell-fonts ttf-fira-code noto-fonts noto-fonts-extra noto-fonts-emoji noto-fonts-cjk ttf-roboto ttf-roboto-mono aspell aspell-de aspell-en hyphen hyphen-de hyphen-en neofetch speech-dispatcher unarchiver most system-config-printer tree atom audacity bleachbit brasero calibre ghidra gimp gimp-help-de gnome-builder handbrake ghc cabal-install haskell-language-server inkscape ipython kdenlive libreoffice-still libreoffice-still-de hunspell-de hunspell-en_us mythes-en mythes-de languagetool libmythes nitroshare obs-studio xreader gnome-keyring qbittorrent steam-manjaro glances virtualbox code vlc evolution )

aur_packages=( 1password preload itch-bin zotero-bin stacer-bin marktext-bin archlinux-artwork arch-logo-dark-wallpapers arch-linux-2d-wallpapers ttf-ms-fonts ttf-hackgen brother-dcpj315w balena-etcher bootstrap-studio edb-debugger-git github-desktop-bin gitkraken guitar-pro ida-free jdownloader2 jetbrains-toolbox kali-undercover kazam libreoffice-extension-languagetool maltego protonmail-bridge-bin rambox-bin remarkable slack-desktop spotify synology-drive synology-note-station nvidia-system-monitor-git virtualbox-ext-oracle yed zoom minecraft-launcher multimc-bin)

snap_packages=( remmina pomotroid )  # optional: flat-remix flat-remix-gtk

flatpak_packages=( "flathub org.signal.Signal" "flathub com.usebottles.bottles" )

logfile=step-2.log

###########################################################
### Alternative ###
#pacman_string=$(join " " ${pacman_packages[@]})
#echo $pacman_string
#pacman -S --needed --no-confirm $pacman_string
###########################################################

# Welcome
echo "#############################################"
echo "########  Arch Linux Post Installer #########"
echo "#############################################"
echo ""
echo -n "Please Enter your Username: ";
read;
username=${REPLY}
echo "Hi $username"
echo ""

mhwd-kernel -li | grep linux 
echo -n "Type the Number above after Linux (e.g. linux515 -> 515)"
read;
kernel_id=${REPLY}
echo ""
echo -n "Installing virtualbox-host-modules "
pacman -S linux$kernel_id-virtualbox-host-modules &>> $logfile
echo "[OK]"

# Prepare Graphe Plugin for IDA-free
echo -n "Installing qwingraph_qt5 "
git clone https://github.com/WqyJh/qwingraph_qt5.git &>> $logfile
cd qwingraph_qt5
sudo ./install.sh &>> $logfile
cd ..
rm -rf qwingraph_qt5
echo "[OK]"

# Prepare Ghidra
echo -n "Preparing Ghidra "
mkdir -p ~/.local/share/ghidra
cp ../resources/ghidra/GHIDRA.svg ~/.local/share/ghidra/
cp ../resources/ghidra/ghidra.desktop ~/.local/share/applications/
chown $USER ~/.local/share/ghidra/GHIDRA.svg
chown $USER ~/.local/share/applications/ghidra.desktop
sudo chgrp users ~/.local/share/ghidra/GHIDRA.svg
sudo chgrp users ~/.local/share/applications/ghidra.desktop
chmod 644 ~/.local/share/ghidra/GHIDRA.svg
chmod 744 ~/.local/share/applications/ghidra.desktop
echo "[OK]"

### Install all Pacman Packages ###
echo "### Installing Pacman Packages ###"
for package in "${pacman_packages[@]}"				  
do	
	echo -n "Installing $package "
	sudo pacman -S --noconfirm --needed $package &>> $logfile
	echo "[OK]"
done


### Installing all AUR Packages ###
mkdir -p tmpaur/
cd tmpaur/
echo "### Installing AUR Packages ###"
for package in "${aur_packages[@]}"				  
do
	echo -n "Installing $package "
	sudo -u $username yay -S --noconfirm --needed $package &>> $logfile
	echo "[OK]"
done
echo ""
cd ..
rm -rf tmpaur

### Installing all Snap Packages ###
echo "### Installing SNAP Packages ###"
for package in "${snap_packages[@]}"				  
do
	echo -n "Installing $package "
	snap install $package &>> $logfile
	echo "[OK]"
done


### Installing all Flatpak Packages ###
echo "### Installing Flatpak Packages ###"
for package in "${flatpak_packages[@]}"				  
do
	echo -n "Installing $package "
	flatpak -y install $package &>> $logfile
	echo "[OK]"
done


### PAMAC ###
#echo -n "Installing flat-remix-gnome "
#pamac install --no-confirm flat-remix-gnome &>> $logfile
#echo "[OK]"
echo "### Installing PAMAC-Mode Packages"
echo -n "Installing flat-remix-gnome "
pamac install --no-confirm balena-etcher &>> $logfile
echo "[OK]"

echo -n "Starting Battery Saving Service "
sudo systemctl enable tlp &>> $logfile
sudo systemctl start tlp &>> $logfile
echo "[OK]"

echo "ALL DONE"
echo "If Balena-Etcher is not installed, feel free to open the appimage in the resource folder"
echo "Now continue with Step 3"

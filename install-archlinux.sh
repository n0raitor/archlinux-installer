#!/bin/bash

#################################
######### CONFIGURATION #########
##### (Later in Config File) ####
#################################
RELEASE_VERSION="0.2.0 Private Alpha"

LOADKEY=de-latin1
LOCAL_MIRROR_COUNTRY='Germany'
NUMBER_OF_MIRRORS=2
HOSTNAME=myhost
KEYMAP=de-latin1
FONT=lat9w-16
LANG=de_DE.UTF-8
declare -a LOCALE=("de_DE.UTF-8 UTF-8" "de_DE ISO-8859-1" "de_DE@euro ISO-8859-15" "en_US.UTF-8")
TIMEZONE=/usr/share/zoneinfo/Europe/Berlin

logfile="archinstall.log"

#################################
##### Function Definitions ######
#################################

#########################
##### Script Part 1 #####
#########################

func_prologue() {
	# Are You Reads?

	read -p "Hello, are you ready to install ArchLinux - N0Raitor Editon? (Press Enter) " ready
	echo "Perfect!"
	sleep 1
	echo "Let's start"
	sleep 1
}

func_loadkeys() {
	# Set Charset for Keyboard-Input

	echo -n "LoadKeys \"$LOADKEY\" "
	loadkeys $LOADKEY
	echo "[OK]"
}

func_connect_to_lan() {
	echo "Connection To LAN TODO!"
}

func_connect_to_wifi() {
	# Helps to connect to a WIFI Hotspot

	#echo ""
	#echo -n "Scanning Network Device..."
	#iwctl
	#listOfDevices=device list	
	#echo " done"
	#echo " Your Network Devices:"
	#echo "$listOfDevices"
	#read -p "Type the device you like to choose: " device
	#iwctl
	echo "Interactive Dialog not implemented yet"
	echo "Opening iwctl (WIFI Connector Program)..."
	echo "HINT: Press \"Help\" for an Introduction"
	iwctl
}

func_internet_connection() {
	# Asks, if LAN or WIFI is suggested and loads the specific module

	connectWifi="-1"
	read -p "Do you wish to use a LAN or WIFI connection? (Type the Word) " connection
	case "$connection" in
		LAN|lan|Lan) connectWifi="0"
		;;
		WIFI|wifi|Wifi) connectWifi="1"
		;;
	esac

	if [ $connectWifi == "-1" ]
	then
		echo "Wrong Input, Choosing LAN"
		func_connect_to_lan
		
	elif [ $connectWifi == "1" ]
	then
		# Connect to WIFI
		echo "Connecting to WIFI..."
		func_connect_to_wifi
	else
		func_connect_to_lan
	fi
}

func_check_internet_connection() {
	# Checks, if an internet connection is available

	echo -n "Checking IPv4 "
	if ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
	  	echo "[OK]"
	else
	  	echo "[ERROR]"
	  	echo "Exiting..."
	  	exit 1
	fi

	echo -n "Checking Network "
	if ping -q -c 1 -W 1 google.com >/dev/null; then
	  	echo "[OK]"
	else
	  	echo "[ERROR]"
	  	echo "Exiting..."
	  	exit 1
	fi

	echo -n "Checking HTTP connectivity "
	case "$(curl -s --max-time 2 -I http://google.com | sed 's/^[^ ]*  *\([0-9]\).*/\1/; 1q')" in
		[23])	echo "[OK]";;
		5)    	echo "[The web proxy won't let us through]";;
		*)    	echo "[The network is down or very slow]"
		   	echo "Exiting..."
		   	exit 1
		   	;;
	esac

	echo "Internet Connection Check successful"
	sleep 1
}

func_release_notes() {
	echo "Welcome to ArchLinux-Installer by N0Raitor"
	echo "Version: $RELEASE_VERSION"
	echo ""
	sleep 1
}

func_partitioning() {
	# Creating Partitions, LVM, Formating, Mounting

	# Variables
	deviceRoot=""
	separatehome=0  # 1 if to create the home directory on a separe device
	separatehomedevice=""
	
	echo ""
	echo "##### PARTITIONING #####"
	echo ""
	lsblk
	echo ""
	
	# Set Root Device via input
	read -p "Select the ROOT device from the output above to install archlinux base system to (e.g. sda): " deviceRoot
	echo ""

	# Separate Home Partition Device?
	#while true; do
    #		read -p "Do you wish to use a separate device for your home directory? (This option will use the entire memory on the device for the home partition. Make sure to backup your data on this device before typing YES [Y/N] " yn
    #		case $yn in
	#		[Yy]* ) separatehome=1; break;;
	#		[Nn]* ) separatehome=0; break;;
	#		* ) echo "Please answer yes or no.";;
    #		esac
	#done
	
	#if [ $separatehome == 1 ]
	#then
	#	# Set Root Device via input
	#	lsblk
	#	read -p "Select the device for your HOME-Directory: " separatehomedevice
	#fi
	
	#echo ""
	#echo "!!!CAUTION!!!"
	#echo "Process Starts in 10 seconds. This process will create a new GPT Partition Table on the selected devices"
	#echo "Press Ctrl+C to exit"
	#sleep 10
	echo -n "Create Root Device "
	sgdisk -o /dev/$deviceRoot  &>> $logfile # Create GPT Table
	sgdisk -n 128:-200M: -t 128:ef00 &>> $logfile /dev/$deviceRoot  # Create EFI / Boot Partition
	sgdisk -n 1:: -t 1:8e00 /dev/$deviceRoot &>> $logfile # Create Linux LVM Partition
	echo "[OK]"
	
	#if [ $separatehome == 1 ]
	#then
	#	echo -n "Create Home Device..."
	#	sgdisk -o /dev/$separatehomedevice  # Create GPT Table
	#	sgdisk -n 1:: /dev/$separatehomedevice  # Create Linux ext4 Partition
	#	echo " done"
	#	echo ""
	#fi
	
	### Create Encrypted Device ###
	echo -n "Set up root partition encryption on \"/dev/${deviceRoot}1\""
	echo "Enter A Password for your Root-Partition:"
	cryptsetup luksFormat /dev/${deviceRoot}1 &>> $logfile
	
	echo "Enter The Password you set for your Root-Partition:"
	cryptsetup open /dev/${deviceRoot}1 cryptlvm &>> $logfile

	echo -n "Set up Volume Group "
	
	#echo -n "Create Physical Volume"
	pvcreate /dev/mapper/cryptlvm &>> $logfile
	#echo " done"
	
	#echo -n "Create Volume Group"
	vgcreate vg1 /dev/mapper/cryptlvm &>> $logfile
	#echo " done"
	
	echo "[OK]"

	# SWAP
	read -p "How Much Swap Memory do you want to use? (in GB) " swapspace
	echo -n "Creating Group Member "
	lvcreate -L ${swapspace}G vg1 -n swap &>> $logfile
	lvcreate -l 100%FREE vg1 -n root &>> $logfile
	echo "[OK]"
	
	### Formating Partitions ###
	echo -n "Formating Partitions "
	mkfs.fat -F32 /dev/sda128 &>> $logfile
	mkfs.ext4 /dev/vg1/root &>> $logfile
	mkswap /dev/vg1/swap &>> $logfile
	
	#if [ $separatehome == 1 ]
	#then
	#	mkfs.ext4 /dev/${separatehomedevice}1
	#fi
	
	echo "[OK]"
	
	### Mounting Partitions ###
	echo -n "Mounting Partitions "
	mount /dev/vg1/root /mnt &>> $logfile
	mkdir /mnt/home &>> $logfile
	#if [ $separatehome == 1 ]
	#then
	#	mount /dev/${separatehomedevice}1 /mnt/home
	#fi
	mkdir /mnt/boot &>> $logfile
	mount /dev/${deviceRoot}128 /mnt/boot &>> $logfile
	swapon /dev/vg1/swap &>> $logfile
	echo "[OK]"
}

func_gen_mirror_list() {
	echo -n "Generating $NUMBER_OF_MIRRORS Mirror List Entries "
	reflector --verbose --country $LOCAL_MIRROR_COUNTRY -l $NUMBER_OF_MIRRORS -p https --sort rate --save /etc/pacman.d/mirrorlist &>> $logfile
	echo "[OK]"
}

func_install_base() {
	echo -n "Installing Base System "
	pacstrap /mnt base base-devel linux-lts linux linux-headers linux-lts-headers linux-firmware nano dhcpcd lvm2 reflector git &>> $logfile
	echo "[OK]"
}

func_config_archlinux() {
	echo -n "Config ArchLinux "
	
	# Set Computer Hostname
	echo $HOSTNAME > /mnt/etc/hostname
	 
	# Set Keyboard Layout
	echo KEYMAP=$KEYMAP > /mnt/etc/vconsole.conf  

	# Set Font (optional)
	echo FONT=$FONT >> /mnt/etc/vconsole.conf  

	# Set Locale
	echo LANG=$LANG > /mnt/etc/locale.conf  # Set Language
	
	# nano /etc/locale.gen
	# -> uncomments this:
	#de_DE.UTF-8 UTF-8
	#de_DE ISO-8859-1
	#de_DE@euro ISO-8859-15
	#en_US.UTF-8
	for lang in ${LOCALE[@]}
	do
		match="#${lang}"
		insert="$lang"
		file="/mnt/etc/locale.gen"
		sed -i "s/$match/$insert/" $file
	done

	echo "[OK]"

	echo -n "Generate FSTAB file "
	# Gererate fstab
	genfstab -U /mnt >> /mnt/etc/fstab  # (alt. change -U to -L to use Label instead of UUID
	
	echo "[OK]"
	
	cat /mnt/etc/fstab &>> $logfile  # check gen

	#read -p "(Press Enter to Continue) " ready
	
	#while true; do
    #		read -p "Do you wish to edit the fstab file (y/n)? " yn
	#    	case $yn in
	#		[Yy]* ) nano /mnt/etc/fstab; break;;
	#		[Nn]* ) break;;
	#		* ) echo "Please answer yes or no.";;
	#    	esac
	#done
	echo -n "Edit hosts file "
	echo "127.0.0.1		localhost.localdomain	localhost" >> /mnt/etc/hosts
	echo "::1		localhost.localdomain	localhost" >> /mnt/etc/hosts
	echo "127.0.0.1		$hostname.localdomain	$hostname" >> /mnt/etc/hosts
	echo "[OK]"
}

func_script_part1() {
	echo "Welcome to ArchLinux-Installer by N0Raitor"
	sleep 1

	### Prologue ###
	func_prologue

	### LoadKeys ###
	func_loadkeys

	### INTERNET CONNECTION ###
	func_internet_connection

	### Check internet Connection ###
	func_check_internet_connection

	### Hinweise - Note ###
	func_release_notes

	### Updating Database ###
	pacman -Syyy &>> $logfile

	### Preconfig ###
	export EDITOR=nano

	### Partitioning ###
	func_partitioning

	### Gen Mirror List ###
	func_gen_mirror_list

	### Install Base Packages ###
	func_install_base
	
	### Config Arch Linux ###
	func_config_archlinux

	### Copy Script to Root Dir on the ArchLinux Install
	cp -v install-archlinux.sh /mnt/root/install-archlinux.sh
	echo "${deviceRoot}" >> /mnt/root/device.info
	# TODO -> Copy other Important / Urgent Files
	
	### Change To Root Directory (Arch-ChRoot) ### TODO
	echo "Changing to ArchLinux Root and continue script (in 3 Seconds)"
	sleep 3
	arch-chroot /mnt /root/install-archlinux.sh continue
	}

#########################
##### Script Part 2 #####
#########################

func_post_arch_chroot_config() {
	echo -n "Post Config in Arch-Chroot "
	# Generate Locale
	locale-gen &>> $logfile
	
	# Set Time
	ln -sf $TIMEZONE /etc/localtime  &>> $logfile # Set Timezone
	hwclock --systohc --utc &>> $logfile # Sync Hardware-Clock
	
	echo "[OK]"

	# Set Root Password
	echo "Set your ROOT Password"
	passwd root
	
	# Generate Mirror List for ArchLinux System
	echo -n "Generating $NUMBER_OF_MIRRORS Mirror List Entries "
	reflector --verbose --country $LOCAL_MIRROR_COUNTRY -l $NUMBER_OF_MIRRORS -p https --sort rate --save /etc/pacman.d/mirrorlist &>> $logfile
	echo "[OK]"

	# Manipulate MKINICPIO - TODO - Kritische Stelle bei einem ISO Update, im AUGE Behalten beim Testing
	echo -n "Edit Mkinitcpio "
	match="block filesystems"
	insert="block encrypt lvm2 filesystems"
	file="/etc/mkinitcpio.conf"
	sed -i "s/$match/$insert/" $file
	echo "[OK]"
	echo -n "Gen Mkinitcpio "
	mkinitcpio -p linux-lts &>> $logfile
	mkinitcpio -p linux &>> $logfile
	echo "[OK]"
	
	
	### GRUB ###
	echo -n "Config GRUB Bootloader "
	pacman -S --noconfirm grub efibootmgr &>> $logfile
	grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB &>> $logfile
	
	rootdevice=$(cat device.info)

	echo -n "Edit Grub Default File "
	match_GRUB="GRUB_CMDLINE_LINUX_DEFAULT"
	insert_GRUB="GRUB_CMDLINE_LINUX_DEFAULT=\"cryptdevice=/dev/${rootdevice}:cryptlvm:allow-discards loglevel=3\" # "
	echo $insert_GRUB
	file_GRUB="/etc/default/grub"
	sed -i "s/$match_GRUB/$insert_GRUB/" $file_GRUB
	echo " done"

	# TODO Same with other default grub sections
	
	grub-mkconfig -o /boot/grub/grub.cfg  # Generate Grub config file
	
	echo ""
	echo "BASE SYSTEM INSTALLED and BASE CONFIG DONE"
	echo ""
}

func_setup_arch_linux_root() {
	echo "func_setup_arch_linux_root TODO" # TODO
}

func_leave_arch_chroot() {
	exit
	umount -a
	reboot
}

func_script_part2() {
	echo "#####################################################"
	echo "#  Arch Linux Base System - Arch-ChRoot Post Script #"
	echo "#####################################################"
	echo ""
	# Post Arch-ChRoot Configuration and Generation
	func_post_arch_chroot_config
	
	func_setup_arch_linux_root

	func_leave_arch_chroot
}


arch-chroot /mnt  # Switch Back to Root


#########################
##### Main Methode ######
#########################
script_part="$1"

if [ $script_part == "continue" ]
then
	func_script_part2
else
	func_script_part1
fi
	





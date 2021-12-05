#!/bin/bash

#################################
######### CONFIGURATION #########
##### (Later in Config File) ####
#################################
LOADKEY=de-latin1
LOCAL_MIRROR_COUNTRY='Germany'
NUMBER_OF_MIRRORS=200
HOSTNAME=myhost
KEYMAP=de-latin1
FONT=lat9w-16
LANG=de_DE.UTF-8
LOCALE=("de_DE.UTF-8 UTF-8" "de_DE ISO-8859-1" "de_DE@euro ISO-8859-15" "en_US.UTF-8")
TIMEZONE=/usr/share/zoneinfo/Europe/Berlin


#################################
##### Function Definitions ######
#################################

func_prologue() {
	# Are You Reads?
	read -p "Hello, are you ready to install ArchLinux? (Press Enter)" ready
	echo "Perfect!"
	sleep 1
	echo "Let's start"
	sleep 1

}

func_loadkeys() {
	echo -n "LoadKeys..."
	loadkeys $LOADKEY
	echo " done"
}

func_connect_to_wifi() {
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
	iwctl
	help
}

func_internet_connection() {
	connectWifi="-1"
	read -p "Do you use a LAN or WIFI connection? (Type the Word)" connection
	case "$connection" in
		LAN|lan|Lan) connectWifi="0"
		;;
		WIFI|wifi|Wifi) connectWifi="1"
		;;
	esac

	if [ $connectWifi == "-1" ]
	then
		echo "Wrong Input"
		echo "Exiting..."
		exit 1
		
	elif [ $connectWifi == "1" ]
	then
		# Connect to WIFI
		echo "Connecting to WIFI..."
		func_connect_to_wifi
	fi
}

func_check_internet_connection() {
	if ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
	  	echo "IPv4 is up"
	else
	  	echo "IPv4 is down"
	  	echo "Exiting..."
	  	exit 1
	fi

	if ping -q -c 1 -W 1 google.com >/dev/null; then
	  	echo "The network is up"
	else
	  	echo "The network is down"
	  	echo "Exiting..."
	  	exit 1
	fi

	case "$(curl -s --max-time 2 -I http://google.com | sed 's/^[^ ]*  *\([0-9]\).*/\1/; 1q')" in
		[23])	echo "HTTP connectivity is up";;
		5)    	echo "The web proxy won't let us through";;
		*)    	echo "The network is down or very slow"
		   	echo "Exiting..."
		   	exit 1
		   	;;
	esac

	echo "You have an Internet Connection :D"
	sleep 1
}

func_release_notes() {
	echo "Welcome to ArchLinux-Installer by NormannatoR"
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
	read -p "Select the ROOT device to install archlinux base system to: " deviceRoot
	
	# Separate Home Partition Device?
	
	while true; do
    		read -p "Do you wish to use a separate device for your home directory? (This option will use the entire memory on the device for the home partition. Make sure to backup your data on this device before typing YES [Y/N]" yn
    		case $yn in
			[Yy]* ) separatehome=1; break;;
			[Nn]* ) separatehome=0; break;;
			* ) echo "Please answer yes or no.";;
    		esac
	done
	
	if [ $separatehome == 1 ]
	then
		# Set Root Device via input
		lsblk
		read -p "Select the device for your HOME-Directory: " separatehomedevice
	fi
	
	echo ""
	echo "!!!CAUTION!!!"
	echo "Process Starts in 10 seconds. This process will create a new GPT Partition Table on the selected devices"
	echo "Press Ctrl+C to exit"
	echo ""
	sleep 10
	echo "Create Root Device..."
	sgdisk -o /dev/$deviceRoot  # Create GPT Table
	sgdisk -n 128:-200M: -t 128:ef00 /dev/$deviceRoot  # Create EFI / Boot Partition
	sgdisk -n 1:: -t 1:8e00 /dev/$deviceRoot  # Create Linux LVM Partition
	echo " done"
	echo ""
	
	if [ $separatehome == 1 ]
	then
		echo -n "Create Home Device..."
		sgdisk -o /dev/$separatehomedevice  # Create GPT Table
		sgdisk -n 1:: /dev/$separatehomedevice  # Create Linux LVM Partition
		echo " done"
		echo ""
	fi
	
	### Create Encrypted Device ###
	echo "Set up Encryption..."
	cryptsetup luksFormat /dev/${deviceRoot}1
	echo "Encrypting Root Partition... done"
	echo "Enter The Password you set for your Root-Partition:"
	cryptsetup open /dev/${deviceRoot}1 cryptlvm
	
	#echo -n "Create Physical Volume"
	pvcreate /dev/mapper/cryptlvm
	#echo " done"
	
	#echo -n "Create Volume Group"
	vgcreate vg1 /dev/mapper/cryptlvm
	#echo " done"
	
	read -p "How Much Swap Memory do you want to use? (in GB)" swapspace
	echo -n "Creating Group Member..."
	lvcreate -L ${swapspace}G vg1 -n swap
	lvcreate -l 100%FREE vg1 -n root
	echo " done"
	
	### Formating Partitions ###
	echo -n "Formating Partitions..."
	mkfs.fat -F32 /dev/sda128
	mkfs.ext4 /dev/vg1/root
	mkswap /dev/vg1/swap
	
	if [ $separatehome == 1 ]
	then
		mkfs.ext4 /dev/${separatehomedevice}1
	fi
	
	echo " done"
	
	### Mounting Partitions ###
	echo -n "Mounting Partitions..."
	mount /dev/vg1/root /mnt
	mkdir /mnt/home
	if [ $separatehome == 1 ]
	then
		mount /dev/${separatehomedevice}1 /mnt/home
	fi
	mkdir /mnt/boot
	mount /dev/${deviceRoot}128 /mnt/boot
	swapon /dev/vg1/swap
	echo " done"
	echo ""
}

func_gen_mirror_list() {
	echo ""
	echo "### Gen Mirror List ###"
	reflector --verbose --country $LOCAL_MIRROR_COUNTRY -l $NUMBER_OF_MIRRORS -p https --sort rate --save /etc/pacman.d/mirrorlist
	echo ""
}

func_install_base() {
	echo "##### Installing Base System #####"
	echo "Note: The LTS-Kernal will get installed"
	pacstrap /mnt base base-devel linux-lts linux-firmware nano vim dhcpcd lvm2 reflector
	echo ""
	echo "Installation of the Base System DONE"
	echo ""
}

func_config_archlinux() {
	echo "##### Config ArchLinux #####"
	echo ""
	
	# Set Computer Hostname
	echo $HOSTNAME > /etc/hostname
	 
	# Set Keyboard Layout
	echo KEYMAP=$KEYMAP > /etc/vconsole.conf  

	# Set Font (optional)
	echo FONT=$FONT >> /etc/vconsole.conf  

	# Set Locale
	echo LANG=$LANG > /etc/locale.conf  # Set Language
	
	# nano /etc/locale.gen
	# -> uncomments this:
	#de_DE.UTF-8 UTF-8
	#de_DE ISO-8859-1
	#de_DE@euro ISO-8859-15
	#en_US.UTF-8
	for lang in "${LOCALE}"
	do
		match="#" & $lang
		insert=$lang
		file="/etc/locale.gen"
		sed -i "s/$match/$match\n$insert/" $file
	done
	
	locale-gen

	# Set Time
	ln -sf $TIMEZONE /etc/localtime  # Set Timezone
	hwclock --systohc --utc # Sync Hardware-Clock

	# Set Root Password
	echo ""
	echo "Set your ROOT Password"
	passwd root
	exit
	
	# Gererate fstab
	genfstab -U /mnt >> /mnt/etc/fstab  # (alt. change -U to -L to use Label instead of UUID
	
	echo ""
	echo "The Generated fstab file:"
	cat /mnt/etc/fstab  # check gen
	read "(Press Enter to Continue)"

	arch-chroot /mnt  # Switch Back to Root
	
	while true; do
    		read -p "Do you wish to edit the fstab file (y/n)?" yn
	    	case $yn in
			[Yy]* ) nano /etc/fstab; break;;
			[Nn]* ) break;;
			* ) echo "Please answer yes or no.";;
	    	esac
	done
	
	echo "127.0.0.1		localhost.localdomain	localhost" >> /etc/hosts
	echo "::1		localhost.localdomain	localhost" >> /etc/hosts
	echo "127.0.0.1		$hostname.localdomain	$hostname" >> /etc/hosts
	
}

#########################
##### Script Part 1 #####
#########################
func_script_part1() {
	echo "Welcome to ArchLinux-Installer by NormannatoR"
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
	pacman -Syyy

	### Preconfig ###
	export EDITOR=nano

	### Partitioning ###
	func_partitioning

	### Gen Mirror List ###
	func_gen_mirror_list

	### Install Base Packages ###
	func_install_base

	### Copy Script to Root Dir on the ArchLinux Install
	cp -v install-archlinux.sh /mnt/root/install-archlinux.sh
	# TODO -> Copy other Important / Urgent Files

	### Change To Root Directory (Arch-ChRoot) ###
	echo "Changing to ArchLinux Root"
	arch-chroot /mnt /root/install-archlinux.sh continue
	}

#########################
##### Script Part 2 #####
#########################
func_script_part2() {
	### Config Arch Linux ###
	func_config_archlinux
}

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
	





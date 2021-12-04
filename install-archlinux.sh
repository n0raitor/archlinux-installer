#!/bin/bash

#################################
######### CONFIGURATION #########
##### (Later in Config File) ####
#################################
LOADKEY=de-latin1


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
	echo "TODO"
	sleep 10
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
	sleep 1
}

#########################
##### Main Methode ######
#########################
echo "Welcome to ArchLinux-Installer by NormannatoR"
sleep 1

### Prologue ###
#func_prologue

### LoadKeys ###
#func_loadkeys

### INTERNET CONNECTION ###
#func_internet_connection

### Check internet Connection ###
#func_check_internet_connection

### Hinweise - Note ###
#func_release_notes



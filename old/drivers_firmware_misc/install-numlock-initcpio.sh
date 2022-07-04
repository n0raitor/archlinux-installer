#!/bin/bash

yay -S mkinitcpio-numlock

read -p "Now add \"numlock\" in front of the encrypt (or modconf) to ensure that numlock is enabled on bootup. Then Regenerate initramfs."

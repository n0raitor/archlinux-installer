#!/bin/bash

 curl -sS https://downloads.1password.com/linux/keys/1password.asc | gpg --import

 yay -S 1password

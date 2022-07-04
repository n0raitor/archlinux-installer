#!/bin/bash

git clone https://github.com/WqyJh/qwingraph_qt5.git
cd qwingraph_qt5
sudo ./install.sh
cd ..
rm -rf qwingraph_qt5

yay -S ida-free

#!/bin/bash

pacman -S python python-pip

pacman -S python-distutils-extra  # For PyCharm Venv Packages

# For Python Code Checking
pip install pylint  # maybe pip3

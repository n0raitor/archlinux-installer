#!/bin/bash

sudo mkdir /var/lib/pgadmin
sudo mkdir /var/log/pgadmin
sudo chown $USER /var/lib/pgadmin
sudo chown $USER /var/log/pgadmin
python3 -m venv pgadmin4
source pgadmin4/bin/activate

# In pgadmin 4 VENV
pip install pgadmin4

pip install jinja2==3.0.3

# Execute with: python ~/pgadmin4/lib/python3.10/site-packages/pgadmin4/pgAdmin4.py

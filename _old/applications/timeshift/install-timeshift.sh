#!/bin/bash

yay -S timeshift timeshift-autosnap

systemctl enable cronie.service
systemctl start cronie.service

#!/bin/bash

yay -S timeshift

systemctl enable cronie.service
systemctl start cronie.service

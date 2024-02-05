#!/bin/bash

sudo apt update
sudo apt install cups
sudo usermod -a -G lpadmin pi
sudo cupsctl --remote-any
service cups status
ifconfig

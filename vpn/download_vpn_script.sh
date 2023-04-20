#!/bin/bash

sudo su -

# install wget
apt-get install wget

# install VPN related services
wget -P /root -N --no-check-certificate "https://raw.githubusercontent.com/mack-a/v2ray-agent/master/install.sh" && chmod 700 /root/install.sh && /root/install.sh

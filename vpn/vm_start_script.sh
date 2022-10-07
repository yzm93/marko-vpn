#!/bin/bash

# install wget
sudo apt-get install wget

# install terraform 
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common

wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

gpg --no-default-keyring \
    --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    --fingerprint

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update

sudo apt-get install terraform

# install VPN related services
wget -P /root -N --no-check-certificate "https://raw.githubusercontent.com/mack-a/v2ray-agent/master/install.sh" && chmod 700 /root/install.sh

# install and configure git
sudo apt-get install git-all -y

git config --global user.email "yingzhengma@gmail.com"

git config --global user.name "yzm93"

# initialize workspace and clone and configure terraform repo
mkdir workspace && cd workspace

git clone https://github.com/yzm93/terraform.git && cd terraform && terraform init

# TODO: Need to auth to the new trial account  
# gcloud auth login --no-launch-browser --update-adc
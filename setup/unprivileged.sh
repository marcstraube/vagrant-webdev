#!/usr/bin/env bash

#
# This script contains tasks that need to be run as the 'vagrant' user instead of 'root'.
#

# Vagrant synced dir
DIR="/srv/http"

# Configure .bashrc
cp /vagrant/setup/config/bash/bashrc /home/vagrant/.bashrc
mkdir /home/vagrant/.bashrc.d
cp /vagrant/setup/config/bash/bashrc.d/* /home/vagrant/.bashrc.d/

# Install yay pacman wrapper.
git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay
makepkg -si --noconfirm

# Install Mercure
#yay -S --noconfirm mercure

# Install Symfony CLI
yay -S --noconfirm symfony-cli

# Install Vue CLI
yay -S --noconfirm vue-cli

# Clear yay and pacman cache.
yay -Sc --noconfirm
sudo paccache -rk0

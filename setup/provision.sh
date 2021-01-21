#!/usr/bin/env bash

#
# System configuration
#

# Set root password
echo "root:vagrant" | chpasswd

# Set correct timezone.
timedatectl set-timezone Europe/Berlin

# Update system.
pacman -Syu --noconfirm

# Install basic system tools.
pacman -S --noconfirm --needed base-devel \
  bash-completion git most neovim pacman-contrib rxvt-unicode-terminfo unzip wget zip

# Create and install a CA and certificates
pacman -S --noconfirm mkcert
CAROOT="/vagrant/setup/tls/" mkcert -install
CAROOT="/vagrant/setup/tls/" mkcert \
  -cert-file "/etc/ssl/certs/devbox.local.pem" \
  -key-file "/etc/ssl/private/devbox.local-key.pem" \
  devbox.local *.devbox.local localhost 127.0.0.1 ::1
chmod 644 /etc/ssl/private/devbox.local-key.pem

# Install and configure Postfix.
pacman -S --noconfirm s-nail postfix
cp /vagrant/setup/config/postfix/* /etc/postfix/
postalias /etc/postfix/aliases
systemctl enable postfix.service
systemctl start postfix.service


#
# Web development environment configuration
#

# Install and configure Apache HTTPd with PHP and Xdebug.
pacman -S --noconfirm apache php php-fpm php-intl xdebug
cp /vagrant/setup/config/apache/httpd.conf /etc/httpd/conf/httpd.conf
cp /vagrant/setup/config/apache/extra/* /etc/httpd/conf/extra/
cp /vagrant/setup/config/php/php.ini /etc/php/php.ini
cp /vagrant/setup/config/php/conf.d/* /etc/php/conf.d/
systemctl enable php-fpm.service
systemctl start php-fpm.service
systemctl enable httpd.service
systemctl start httpd.service

# Install and configure MariaDB.
pacman -S --noconfirm mariadb
mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
cp /vagrant/setup/config/mariadb/*.cnf /etc/my.cnf.d/
systemctl enable mysqld.service
systemctl start mysqld.service
mysql -uroot < /vagrant/setup/database/privileges.sql

# Install Composer.
pacman -S --noconfirm composer

# Install Yarn
pacman -S --noconfirm yarn

# Install Sassc.
pacman -S --noconfirm sassc

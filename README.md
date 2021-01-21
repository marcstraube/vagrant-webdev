# Vagrant Web Development Environment

## What's in it?

* Arch Linux
* Postfix
* Apache with SSL
* PHP-FPM
* Xdebug
* MariaDB
* Mercure
* Composer
* Yarn
* Symfony CLI
* Vue CLI

## Installation of the Development Environment

### Requirements

* Vagrant
* VirtualBox

#### Linux

* nfsd

### Install required Vagrant Plugins

```
vagrant plugin install vagrant-reload
vagrant plugin install vagrant-notify-forwarder
vagrant plugin install vagrant-hostsupdater
```

### Install the root certificate

During provisioning ot the VM a root CA certificate is created and stored at ```setup/tls/```. This root CA certificate
is used to create the server certificates.

#### Linux

Use ```mkcert``` for easy installation of the certificate on your host machine.

```
CAROOT="./setup/tls/" mkcert -install
```

### Edit your VM settings

The ```Vagrantfile``` is configurable via an external configuration file. Copy ```vagrant.yml.dist``` to
```vagrant.yml``` and edit the settings to your desire.

You also can set the ```DEVBOX_APP_DIR``` environment variable, if you want to use another directory for your app
than ```./app```.

### Start the VM

Start the VM with ```vagrant up``` and use ```vagrant ssh``` to log into it.

## Cheat Sheet

* HTTP: ```http://devbox.local:10080```
* HTTPS: ```https://devbox.local:10443```
* MariaDB: ```devbox.local:13306```
* Xdebug ```devbox.local:19003```
* Linux ```root``` password: ```password```
* Database ```root``` password: ```password```

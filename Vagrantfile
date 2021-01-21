require 'yaml'

# Load settings from vagrant.yml or vagrant.yml.dist
current_dir = File.dirname(File.expand_path(__FILE__))
if File.file?("#{current_dir}/vagrant.yml")
    config_file = YAML.load_file("#{current_dir}/vagrant.yml")
else
    config_file = YAML.load_file("#{current_dir}/vagrant.yml.dist")
end
settings = config_file

app_dir = ENV['DEVBOX_APP_DIR'] || "./app"

Vagrant.configure("2") do |config|
  config.vm.box = "archlinux/archlinux"

  # Set the hostname.
  config.vm.hostname = "devbox.local"

  # Configure the network.
  config.vm.network "private_network", type: settings.fetch('vm').fetch('ip')

  # Configure ports.
  config.vm.network "forwarded_port", guest: 80,   host: 10080  # Apache HTTPd
  config.vm.network "forwarded_port", guest: 443,  host: 10443  # Apache HTTPd SSL
  config.vm.network "forwarded_port", guest: 8080, host: 8080   # Encore Dev-Server
  config.vm.network "forwarded_port", guest: 3000, host: 3000   # Mercure
  config.vm.network "forwarded_port", guest: 3306, host: 13306  # MariaDB
  config.vm.network "forwarded_port", guest: 9003, host: 19003   # Xdebug

  # Configure synced folders.
  config.vm.synced_folder ".", "/vagrant",
        type: "nfs",
        nfs_udp: false,
        nfs_version: 4,
        linux__nfs_options: ["rw","no_subtree_check","all_squash","async"]

  config.vm.synced_folder app_dir, "/srv/http",
        type: "nfs",
        nfs_udp: false,
        nfs_version: 4,
        linux__nfs_options: ["rw","no_subtree_check","all_squash","async"]

  # Configure provider.
  config.vm.provider "virtualbox" do |vb|
    # CPU / memory settings.
    vb.cpus = settings.fetch('vm').fetch('cpus')
    vb.memory = settings.fetch('vm').fetch('memory')

    # Enable multi cpu usage.
    vb.customize ["modifyvm", :id, "--ioapic", "on"]

    # Fix slow network speed.
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "off"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "off"]
  end

  # Set up SSH agent forwarding.
  config.ssh.forward_agent = true

  # Runs once while provisioning.
  config.vm.provision "shell", path: "setup/provision.sh"
  config.vm.provision "shell", path: "setup/unprivileged.sh", privileged: false

  # Restart Apache HTTPd on failure to wait for synced_folder to be mounted.
  config.vm.provision "shell", inline: "systemctl restart httpd.service", run: "always"

  # Finished. Reload VM
  config.vm.provision :reload
end

# -*- mode: ruby -*-
# vi: set ft=ruby :
require_relative 'provisioning/vbox.rb'
VBoxUtils.check_version('7.0.6')
Vagrant.require_version ">= 2.3.4"

class VagrantPlugins::ProviderVirtualBox::Action::Network
  def dhcp_server_matches_config?(dhcp_server, config)
    true
  end
end

Vagrant.configure("2") do |config|
    # Box and hostname settings
    config.vm.box = "ubuntu/focal64"
    config.vm.box_version = "20230202.0.0"
    config.vm.box_check_update = false
    config.vm.hostname = "idc-aisi2223"

    # Network and port forwarding settings
    config.vm.network "forwarded_port", guest: 80, host: 8080
    config.vm.network "private_network", type: "dhcp"
    config.vm.network "private_network", ip: "192.168.56.10", netmask: "255.255.255.0"

    # Synced folder
    config.vm.synced_folder "html/", "/var/www/html", mount_options: ["dmode=755,fmode=644"]

    # Configure hostmanager plugin
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.manage_guest = true

    # Provider-specific customizations (CPU, memory, disk...)
    config.vm.provider "virtualbox" do |vb|
	vb.name = "AISI-P0-#{config.vm.hostname}"
	vb.gui = false
	vb.cpus = 2
	vb.memory = 2048

	sasController = "SAS Controller"
	disk = "diskVM-SAS.vmdk"
	
	# Create the virtual disk if doesn't exist
	unless File.exist?(disk)
		vb.customize ["createmedium", "disk", "--filename", disk, "--format", "VMDK", "--size", 2048]
	end

	# Add storage SAS controller only when the VM is provisioned for the first time
	unless File.exist?(".vagrant/machines/default/virtualbox/action_provision")
		vb.customize ["storagectl", :id, "--name", sasController, "--add", "sas", "--portcount", 1]
	end

	# Attach the virtual disk into the storage controller
	vb.customize ["storageattach", :id, "--storagectl", sasController, "--port", 1, "--device", 0, "--type", "hdd", "--medium", disk]
    end

    # Embedded provisioning through shell script
    config.vm.provision "shell", run: "once", inline: <<-SHELL
	apt update
	# Complete the following commands
	apt install apache2 -y
	systemctl start apache2
	systemctl enable apache2
	mkfs.ext4 /dev/sda
	mkdir /mnt/idc-aisi2223
    SHELL
    
    # Provisioning through an external shell script
    config.vm.provision "shell", run: "always", path: "provisioning/script.sh", args: "/mnt/idc-aisi2223"
end

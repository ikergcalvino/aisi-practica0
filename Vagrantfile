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
    config.vm.synced_folder "XXX", "XXX", mount_options: ["XXX"]

    # Configure hostmanager plugin
    config.hostmanager.enabled = XXX
    config.hostmanager.manage_host = XXX
    config.hostmanager.manage_guest = XXX

    # Provider-specific customizations (CPU, memory, disk...)
    config.vm.provider "virtualbox" do |vb|
	vb.name = "AISI-P0-#{config.vm.hostname}"
	vb.gui = false
	vb.cpus = 2
	vb.memory = 2

	sasController = "SAS Controller"
	disk = "diskVM-SAS.vmdk"
	
	# Create the virtual disk if doesn't exist
	unless File.exist?(disk)
		vb.customize ["createmedium", "disk", "--filename", "disk01.vmdk", "--format", "VMDK", "--size", 2048]
	end

	# Add storage SAS controller only when the VM is provisioned for the first time
	unless File.exist?(".vagrant/machines/default/virtualbox/action_provision")
		vb.customize ["storagectl", :id, "--name", sasController, "--add", "XXX", "--portcount", XXX]
	end

	# Attach the virtual disk into the storage controller
	vb.customize ["storageattach", :id, "--storagectl", sasController, "--port", XXX, "--device", 0, "--type", "XXX", "--medium", XXX]
    end

    # Embedded provisioning through shell script
    config.vm.provision "shell", run: "XXX", inline: <<-SHELL
	apt update
	# Complete the following commands
	apt install -y
	systemctl
	systemctl
	mkfs.ext4
	mkdir
    SHELL
    
    # Provisioning through an external shell script
    config.vm.provision "shell", run: "XXX", path: "provisioning/script.sh", args: "XXX"
end

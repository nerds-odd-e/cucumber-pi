# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty32"

  config.vm.define "vagrant"

  config.vm.hostname = "atdd.local"

  config.vm.box_check_update = false
  config.vm.network "private_network", type: 'dhcp'

  synced_opts = {}
  if ENV["ENABLE_NFS"] == "true"
    config.vm.network "private_network", type: "dhcp"
    synced_opts = {nfs: true}
  end

  {
    "src" => "/home/vagrant/src"
  }.map { |local_folder, vagrant_folder|
    config.vm.synced_folder *([local_folder, vagrant_folder] << synced_opts)
  }

  config.vm.network "forwarded_port", guest: 80, host: 9000

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", "2048"]

    vb.customize ['modifyvm', :id, '--usb', 'on']
    vb.customize ['usbfilter', 'add', '0', '--target', :id, '--name', 'android', '--vendorid', "#{ENV['ANDROID_VENDOR_ID'] || '0x18d1'}"]
  end

  config.ssh.pty = true
  config.ssh.forward_x11 = true

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "playbook.yml"
  end
end

# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define "vagrant"

  config.vm.box = "bento/ubuntu-18.04"

  config.vm.hostname = "atdd.local"

  config.ssh.pty = true
  config.ssh.forward_x11 = true

  config.vm.network "forwarded_port", guest: 80, host: 9000

  config.vm.provider "virtualbox" do |vb, override|
    vb.customize ["modifyvm", :id, "--memory", "2048"]

    vb.customize ['modifyvm', :id, '--usb', 'on']
    vb.customize ['usbfilter', 'add', '0', '--target', :id, '--name',
                  'android', '--vendorid', "#{ENV['ANDROID_VENDOR_ID'] || '0x18d1'}"]

    synced_opts = {}
    if ENV["ENABLE_NFS"] == "true"
      config.vm.network "private_network", type: "dhcp"
      synced_opts = {nfs: true}
    end

    {
      "src" => "/home/vagrant/src"
    }.map { |local_folder, vagrant_folder|
      override.vm.synced_folder *([local_folder, vagrant_folder] << synced_opts)
    }
  end

  config.vm.provider "aws" do |aws, override|
    override.vm.box = "dummy"
    override.vm.box_check_update = false

    aws.endpoint = ENV['AWS_ENDPOINT'] if ENV['AWS_ENDPOINT']

    aws.region= ENV['AWS_DEFAULT_REGION']
    aws.access_key_id = ENV['AWS_ACCESS_KEY_ID']
    aws.secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']

    aws.ami = ENV['AWS_DEFAULT_AMI']

    aws.instance_type = ENV['AWS_DEFAULT_INSTANCE_TYPE'] || 't2.micro'
    aws.keypair_name = ENV['AWS_DEFAULT_KEYPAIR'] || 'default'

    override.ssh.username = "ubuntu"
    override.ssh.private_key_path = "~/.ssh/id_rsa"

    exclude_files = IO.readlines('.gitignore').map { |item|
      item.chop;
    }.select { |item|
      not item.match(/\s*#/);
    }
    exclude_files << ".git/"

    override.vm.synced_folder ".", "/vagrant", type: "rsync", rsync__exclude: exclude_files
  end

  config.vm.provision "ansible" do |ansible|
    if File.exist?("playbook.yml")
      ansible.playbook = "playbook.yml"
    else
      ansible.playbook = "playbook.yml-example"
    end

    ansible.raw_arguments = []

    unless ENV['ANSIBLE_START_AT_TASK'].nil?
      ansible.raw_arguments << "--start-at-task"
      ansible.raw_arguments.push(ENV['ANSIBLE_START_AT_TASK'])
    end
    unless ENV['ANSIBLE_OPTS'].nil?
      ansible.raw_arguments.concat ENV['ANSIBLE_OPTS'].split(/\s+/)
    end
  end
end

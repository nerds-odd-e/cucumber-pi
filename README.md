# cucumber-pi

## Quick start

    brew update
    brew cask install virtualbox virtualbox-extension-pack vagrant
    brew install ansible
    cp playbook.yml-example playbook.yml
    vagrant up

### Reconfigure the VM

    vagrant provision
    # or
    vagrant reload --provision

## Setup guide for Raspberry Pi
### Step 0: Download Raspbian

Download latest Raspbian from [Raspberry Pi Downloads - Software for the Raspberry Pi](https://www.raspberrypi.org/downloads/), unzip it.

### Step 1: Eject your SD card

Eject your SD card if you have mounted it.

### Step 2: Install Raspbian on your SD card

After running the below command, insert your SD card.

    ./write_sdcard ~/Downloads/2017-08-16-raspbian-stretch.img

During the writing process, press *Ctrl-T* to show the progress.

### Step 3: Enable SSH and Wi-Fi

After running the below command, reinsert your SD card.

    ./sdcard_enable_ssh_and_wifi your_wifi_ssid your_wifi_password

### Step 4: Booting your Raspberry Pi

Insert the SD card into your Raspberry Pi, boot up.

Check your router, or run command `sudo nmap -sn 192.168.0.0/24` to find ip address of your Raspberry Pi. (*192.168.0.0* is your local network)

### Step 5: Done

Using `ssh` to log in. The default password of user `pi` is `raspberry`

# cucumber-pi

## Quick start

    brew update
    brew install caskroom/cask/brew-cask
    brew cask install virtualbox vagrant
    brew install ansible
    copy playbook.yml-example playbook.yml
    vagrant up

### reconfigure vagrant
    vagrant provision
    # or
    vagrant reload --provision

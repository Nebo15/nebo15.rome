#!/usr/bin/env bash
TIMEZONE="Europe/Kiev"
LOCALE_LANGUAGE="en_US"
LOCALE_CODESET="en_US.UTF-8"
sudo locale-gen $LOCALE_LANGUAGE $LOCALE_CODESET
echo "export LANGUAGE=$LOCALE_CODESET" | sudo tee --append /etc/bash.bashrc
echo "export LANG=$LOCALE_CODESET" | sudo tee --append /etc/bash.bashrc
echo "export LC_ALL=$LOCALE_CODESET" | sudo tee --append /etc/bash.bashrc
echo $TIMEZONE | sudo tee /etc/timezone
export LANGUAGE=$LOCALE_CODESET
export LANG=$LOCALE_CODESET
export LC_ALL=$LOCALE_CODESET
sudo dpkg-reconfigure locales
source /etc/lsb-release
wget https://apt.puppetlabs.com/puppetlabs-release-$DISTRIB_CODENAME.deb
sudo dpkg -i puppetlabs-release-$DISTRIB_CODENAME.deb
rm puppetlabs-release-$DISTRIB_CODENAME.deb
sudo apt-get update
sudo apt-get install -y -f puppet git
if [ ! -d "/etc/puppet/environments" ]; then
    sudo mkdir /etc/puppet/environments;
fi
sudo chgrp puppet /etc/puppet/environments
sudo chmod 2775 /etc/puppet/environments
echo '
START=yes
DAEMON_OPTS=""
' | sudo tee --append /etc/default/puppet
sudo service puppet start
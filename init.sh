#!/usr/bin/env bash
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

# Startup options

DAEMON_OPTS=""

' | sudo tee --append /etc/default/puppet

sudo service puppet start

#add new deploy key to the server

ssh-keygen -t rsa -b 4096 -N "" -f ~/.ssh/id_rsa -C "test_www_data_key"

value=$(<~/.ssh/id_rsa.pub)

curldata=$"curl -X POST -H 'Content-type:application/json' -H 'Authorization: bearer 5422f61ca0f9e111ad9a8d6b8dc0d77e61597804' -d '{\"title\":\"test_new_server\", \"key\":\""$value"\"}' \"https://api.github.com/repos/Nebo15/nebo15.rome/keys\""

eval $curldata

eval "$(ssh-agent -s)"

ssh-add ~/.ssh/new_key

git clone -b BestWallet git@github.com:Nebo15/nebo15.rome.git nebo15.rome

sudo puppet apply --modulepath ./nebo15.rome/puppet/modules nebo15.rome/puppet/manifests/init.pp


sudo -u www-data ssh-keygen -t rsa -b 4096 -N "" -f /var/www/.ssh/id_rsa -C "test_www_data_key"

value=$(</var/www/.ssh/id_rsa.pub)

curldata=$"curl -X POST -H 'Content-type:application/json' -H 'Authorization: bearer 5422f61ca0f9e111ad9a8d6b8dc0d77e61597804' -d '{\"title\":\"test_www_data_key\", \"key\":\""$value"\"}' \"https://api.github.com/repos/Nebo15/mbank.api/keys\""

eval $curldata

cd /www

sudo -u www-data git clone -b develop git@github.com:Nebo15/mbank.api.git

cd ~/



sudo puppet apply --modulepath ./nebo15.rome/puppet/modules nebo15.rome/puppet/manifests/nginx_conf_sphinx.pp

sudo -Hu www-data /www/mbank.api/bin/update.sh


#!/usr/bin/env bash
dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
ip="$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')";
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
sudo mkdir /www/
sudo chmod 755 /www/
sudo chown www-data:www-data /www/
sudo mkdir -p /var/www/.ssh
sudo chown -Rf www-data:www-data /var/

#add new deploy key to the server
sudo -u www-data ssh-keygen -t rsa -b 4096 -N "" -f /var/www/.ssh/id_rsa_nebo15_rome -C "key_mbank_api_fonar"
www_data_key=$(</var/www/.ssh/id_rsa_nebo15_rome.pub)
/bin/bash ${dir}/add_deploy_key.sh key_mbank_api_fonar nebo15.rome "${www_data_key}"
echo '
Host gh.nebo15_rome
HostName github.com
IdentityFile ~/.ssh/id_rsa_nebo15_rome' | sudo tee --append /var/www/.ssh/config
sudo -u www-data ssh-keyscan github.com >> ~/.ssh/known_hosts
sudo -u www-data git clone -b mbank.api.fonar git@gh.nebo15_rome:Nebo15/nebo15.rome.git /www/nebo15.rome
sudo puppet apply --modulepath /www/nebo15.rome/puppet/modules /www/nebo15.rome/puppet/manifests/init.pp

sudo -u www-data ssh-keygen -t rsa -b 4096 -N "" -f /var/www/.ssh/id_rsa_mbank_api_fonar -C "key_mbank_api_fonar_master"
mbank_www_data_key=$(</var/www/.ssh/id_rsa_mbank_api_fonar.pub)
/bin/bash ${dir}/add_deploy_key.sh key_mbank_api_fonar mbank.api.fonar "${mbank_www_data_key}"

echo '
Host gh.mbank_api_fonar
HostName github.com
IdentityFile ~/.ssh/id_rsa_mbank_api_fonar' | sudo tee --append /var/www/.ssh/config

sudo -u www-data git clone -b master git@gh.mbank_api_fonar:Nebo15/mbank.api.fonar /www/mbank.api.fonar
sudo puppet apply --modulepath /www/nebo15.rome/puppet/modules /www/nebo15.rome/puppet/manifests/nginx.pp
cd /www/mbank.api.fonar
sudo -Hu www-data composer update
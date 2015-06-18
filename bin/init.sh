#!/usr/bin/env bash
dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
ip="$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')";
/bin/bash ${dir}/pre_script.sh
cd ~/
#add new deploy key to the server
sudo -u www-data ssh-keygen -t rsa -b 4096 -N "" -f /var/www/.ssh/id_rsa_nebo15_rome -C "test_www_data_key"
www_data_key=$(</var/www/.ssh/id_rsa_nebo15_rome.pub)
/bin/bash ${dir}/add_deploy_key.sh new_server_title nebo15.rome "${www_data_key}"
echo '
Host gh.nebo15_rome
HostName github.com
IdentityFile ~/.ssh/id_rsa_nebo15_rome' | sudo tee --append /var/www/.ssh/config
sudo -u www-data ssh-keyscan github.com >> ~/.ssh/known_hosts
sudo -u www-data git clone -b BestWallet git@gh.nebo15_rome:Nebo15/nebo15.rome.git /www/nebo15.rome
sudo puppet apply --modulepath /www/nebo15.rome/puppet/modules /www/nebo15.rome/puppet/manifests/init.pp

sudo -u www-data ssh-keygen -t rsa -b 4096 -N "" -f /var/www/.ssh/id_rsa_mbank_api -C "test_www_data_key2"
mbank_www_data_key=$(</var/www/.ssh/id_rsa_mbank_api.pub)
/bin/bash ${dir}/add_deploy_key.sh new_server_title mbank.api "${mbank_www_data_key}"

echo '
Host gh.mbank_api
HostName github.com
IdentityFile ~/.ssh/id_rsa_mbank_api' | sudo tee --append /var/www/.ssh/config

sudo -u www-data git clone -b develop git@gh.mbank_api:Nebo15/mbank.api.git /www/mbank.api
sudo puppet apply --modulepath /www/nebo15.rome/puppet/modules /www/nebo15.rome/puppet/manifests/nginx_conf_sphinx.pp
sudo -Hu www-data /www/mbank.api/bin/update.sh
#!/usr/bin/env bash
dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
ip="$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')";
/bin/bash ${dir}/pre_script.sh
cd ~/
#add new deploy key to the server
sudo -u www-data ssh-keygen -t rsa -b 4096 -N "" -f /var/www/.ssh/id_rsa -C "test_www_data_key"
www_data_key=$(</var/www/.ssh/id_rsa.pub)
/bin/bash ${dir}/add_deploy_key.sh new_server_title nebo15.rome "${www_data_key}"

git clone -b BestWallet git@github.com:Nebo15/nebo15.rome.git /www/nebo15.rome
sudo puppet apply --modulepath ~/nebo15.rome/puppet/modules /www/nebo15.rome/puppet/manifests/init.pp

/bin/bash ${dir}/add_deploy_key.sh new_server_title mbank.api "${www_data_key}"

cd /www
sudo -u www-data git clone -b develop git@github.com:Nebo15/mbank.api.git
sudo puppet apply --modulepath /www/nebo15.rome/puppet/modules /www/nebo15.rome/puppet/manifests/nginx_conf_sphinx.pp
sudo -Hu www-data /www/mbank.api/bin/update.sh
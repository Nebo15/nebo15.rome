#!/bin/bash
PROJECT_DIR=$(dirname $0)/../
BRANCH=$(git rev-parse --abbrev-ref HEAD)
git pull origin $BRANCH
sudo puppet apply --modulepath /www/nebo15.rome/puppet/modules /www/nebo15.rome/puppet/manifests/init.pp
sudo openssl dhparam -out /etc/ssl/dhparam.pem 4096
sudo puppet apply --modulepath /www/nebo15.rome/puppet/modules /www/nebo15.rome/puppet/manifests/general.pp


#!/bin/bash
PROJECT_DIR=$(dirname $0)/../
BRANCH=$(git rev-parse --abbrev-ref HEAD)
git pull origin $BRANCH
if [ "$BRANCH" = "master" ]; then
    enviroment='prod'
else
    enviroment='dev'
fi
sudo FACTER_server_tags="role:${enviroment}" puppet apply --modulepath /www/nebo15.rome/puppet/modules /www/nebo15.rome/puppet/manifests/init.pp
sudo FACTER_server_tags="role:${enviroment}" puppet apply --modulepath /www/nebo15.rome/puppet/modules /www/nebo15.rome/puppet/manifests/general.pp


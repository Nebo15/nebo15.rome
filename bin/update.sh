#!/bin/bash
PROJECT_DIR=$(dirname $0)/../
BRANCH=$(git rev-parse --abbrev-ref HEAD)
while getopts "e:" OPTION
do
     case ${OPTION} in
         e)
             enviroment=$OPTARG
             ;;
     esac
done

if [${enviroment} == '']
then
echo 'You should use -e environment [dev|prod]';
exit;
fi

git pull origin $BRANCH
sudo FACTER_server_tags="role:${enviroment}" puppet apply --modulepath /www/nebo15.rome/puppet/modules /www/nebo15.rome/puppet/manifests/init.pp
sudo FACTER_server_tags="role:${enviroment}" puppet apply --modulepath /www/nebo15.rome/puppet/modules /www/nebo15.rome/puppet/manifests/general.pp


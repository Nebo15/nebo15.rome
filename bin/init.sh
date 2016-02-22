#!/usr/bin/env bash
dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
ip="$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')";

#set server timezone
TIMEZONE="Europe/Kiev"
LOCALE_LANGUAGE="en_US"
LOCALE_CODESET="en_US.UTF-8"
sudo locale-gen ${LOCALE_LANGUAGE} ${LOCALE_CODESET}
sudo echo "export LANGUAGE=${LOCALE_CODESET}
export LANG=${LOCALE_CODESET}
export LC_ALL=${LOCALE_CODESET} " | sudo tee --append /etc/bash.bashrc
echo ${TIMEZONE} | sudo tee /etc/timezone
export LANGUAGE=${LOCALE_CODESET}
export LANG=${LOCALE_CODESET}
export LC_ALL=${LOCALE_CODESET}
sudo dpkg-reconfigure locales

show_help()
{
cat << EOF
This script download files from remote server and download tar.gz to local machine or remote host.
Usage: $0 options
OPTIONS:
    -b  project branch (master|develop)
    -r  rome branch (BestWallet|mbank.api.fonar etc.)
    -t  github token
    -h  show this message
EOF
}


rome_branch="gandalf" #branch name github.com/Nebo15/nebo15.rome/ with puppet configuration
project="gandalf" #project name for automatic generate public key
environment="local" #default environment

while getopts "t:h:r:" OPTION
do
     case ${OPTION} in
         h)
             show_help
             exit 1
             ;;
         t)
             github_token=$OPTARG
             ;;
         r)
             environment=$OPTARG
             ;;
         ?)
             show_help
             exit
             ;;
     esac
done

add_deploy_key() {
Token=$1
Server_title=$2
Project=$3
Key_ssh=$4

curldata=$"curl -X POST -H 'Content-type:application/json' -H 'Authorization: bearer ${Token}' -d '{\"title\":\""${Server_title}"\", \"key\":\""${Key_ssh}"\"}' \"https://api.github.com/repos/Nebo15/"${Project}"/keys\""
eval ${curldata}
eval "$(ssh-agent -s)"

}

add_host_to_ssh_config() {
    host=$1
    host_name=$2
    file=$3
    echo "
Host ${host}
HostName ${host_name}
IdentityFile ${file}" | sudo tee --append /var/www/.ssh/config
}

#installing latest version of puppet if it not exists
if [ ! -e /usr/bin/puppet ]; then
    source /etc/lsb-release
    wget https://apt.puppetlabs.com/puppetlabs-release-$DISTRIB_CODENAME.deb
    sudo dpkg -i puppetlabs-release-$DISTRIB_CODENAME.deb
    rm puppetlabs-release-$DISTRIB_CODENAME.deb
    sudo apt-get update
    sudo apt-get install -y -f puppet
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
else
    sudo apt-get update
fi;

#installing git if it not exists
if [ ! -e /usr/bin/git ]; then
    sudo apt-get install -y -f git
fi;

#creating dirs for www-data
if [ ! -e /www ]; then
    sudo mkdir /www/
    sudo chmod 755 /www/
    sudo chown www-data:www-data /www/
    sudo mkdir -p /var/www/.ssh
    sudo chown -Rf www-data:www-data /var/www/
fi;

#creating and adding access public key for github if it not exists for cloning nebo15.rome
key_file_name="id_rsa_rome_${rome_branch}_${project}_${ip}"
key_name="${project}_${project_branch}_deployer_${ip}"

if [ ! -f /var/www/.ssh/${key_file_name} ]; then
    sudo -u www-data ssh-keygen -t rsa -b 4096 -N "" -f /var/www/.ssh/${key_file_name} -C "${key_name}"
    www_data_key=$(</var/www/.ssh/${key_file_name}.pub)

    add_deploy_key ${github_token} ${key_name} nebo15.rome "${www_data_key}"
    add_host_to_ssh_config gh.nebo15_rome github.com "~/.ssh/${key_file_name}"
    sudo -Hu www-data ssh -o StrictHostKeyChecking=no www-data@gh.nebo15_rome
fi;

if [ ! -e /www/nebo15.rome ]; then
    sudo -u www-data git clone -b gandalf git@gh.nebo15_rome:Nebo15/nebo15.rome.git /www/nebo15.rome
fi;

#list of projects for cloning
projects=("gandalf.api" "gandalf.web" )

if [ "$environment" != "local" ]
then
    for project_name in ${projects[@]}; do
        #creating and adding public keys for each project in array to github
        project_key_file_name="id_rsa_${project_name}_${ip}"
        if [ ! -f /var/www/.ssh/${project_key_file_name} ]; then
            project_key_name="${project}_${ip}"
            sudo -u www-data ssh-keygen -t rsa -b 4096 -N "" -f /var/www/.ssh/${project_key_file_name} -C "${project_key_name}"
            project_www_data_key=$(</var/www/.ssh/${project_key_file_name}.pub)
            add_deploy_key ${github_token} ${project_key_name} ${project_name} "${project_www_data_key}"
            project_host="gh.${project_name}"
            add_host_to_ssh_config ${project_host} github.com "~/.ssh/${project_key_file_name}"
            sudo -Hu www-data ssh -o StrictHostKeyChecking=no www-data@${project_host}
        fi;
    done;
fi;

#if production generate ssl key by Diffie-Helman algorithm https://en.wikipedia.org/wiki/Diffie%E2%80%93Hellman_key_exchange
if [ "$environment" == "prod" ] && [ ! -e /etc/ssl/dhparam.pem ]
then
    sudo openssl dhparam -out /etc/ssl/dhparam.pem 4096
fi;

#run puppet configs by environment
sudo FACTER_server_tags="role:${environment}" puppet apply --modulepath /www/nebo15.rome/puppet/modules /www/nebo15.rome/puppet/manifests/init.pp
sudo FACTER_server_tags="role:${environment}" puppet apply --modulepath /www/nebo15.rome/puppet/modules /www/nebo15.rome/puppet/manifests/general.pp


sudo FACTER_server_tags="role:local" puppet apply --modulepath /vagrant/puppet/modules /vagrant/puppet/manifests/init.pp
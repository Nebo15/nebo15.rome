#!/usr/bin/env bash
dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
ip="$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')";

projects=("parasport.web")
role="local"

show_help()
{
cat << EOF
This script download files from remote server and download tar.gz to local machine or remote host.
Usage: $0 options
OPTIONS:
    -t  github token
    -h  show this message
EOF
}


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
             role=$OPTARG
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
sudo mkdir -p /www/
sudo chown www-data:www-data /www/
sudo mkdir -p /var/www/.ssh
sudo chown -Rf www-data:www-data /var/www/

if [ "$role" != "local" ]
then
    for project_name in ${projects[@]}; do
        project_key_file_name="id_rsa_${project_name}_${ip}"
        project_key_name="${project}_${ip}"
        sudo -u www-data ssh-keygen -t rsa -b 4096 -N "" -f /var/www/.ssh/${project_key_file_name} -C "${project_key_name}"
        project_www_data_key=$(</var/www/.ssh/${project_key_file_name}.pub)
        add_deploy_key ${github_token} ${project_key_name} ${project_name} "${project_www_data_key}"
        project_host="gh.${project_name}"
        add_host_to_ssh_config ${project_host} github.com "~/.ssh/${project_key_file_name}"
        sudo -Hu www-data ssh -o StrictHostKeyChecking=no www-data@${project_host}
    done;
fi;
#sudo openssl dhparam -out /etc/ssl/dhparam.pem 4096
if [ "$role" != "local" ]
then
    sudo FACTER_server_tags="role:${role}" puppet apply --modulepath /www/nebo15.rome/puppet/modules /www/nebo15.rome/puppet/manifests/init.pp
else
    sudo FACTER_server_tags="role:${role}" puppet apply --modulepath /www/nebo15.rome/puppet/modules /www/nebo15.rome/puppet/manifests/init.pp
fi;
sudo FACTER_server_tags="role:${role}" puppet apply --modulepath /www/nebo15.rome/puppet/modules /www/nebo15.rome/puppet/manifests/general.pp
cd /www/parasport.web/

COMPOSER=$(which composer)
if [ -f ${COMPOSER} ]
then
    sudo -Hu www-data php -d memory_limit=-1 $(which composer) install
fi
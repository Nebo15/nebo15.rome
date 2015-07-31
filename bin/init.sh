#!/usr/bin/env bash
dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
ip="$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')";

show_help()
{
cat << EOF
This script download files from remote server and download tar.gz to local machine or remote host.
Usage: $0 options
OPTIONS:
    -p  project (github project name)
    -b  project branch (master|develop)
    -r  rome branch (BestWallet|mbank.api.fonar etc.)
    -t  github token
    -h  show this message
EOF
}


while getopts "p:b:r:t:h:" OPTION
do
     case ${OPTION} in
         h)
             show_help
             exit 1
             ;;
         p)
             project=$OPTARG
             ;;
         b)
             project_branch=$OPTARG
             ;;
         r)
             rome_branch=$OPTARG
             ;;
         t)
             github_token=$OPTARG
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
sudo mkdir /www/
sudo chmod 755 /www/
sudo chown www-data:www-data /www/
sudo mkdir -p /var/www/.ssh
sudo chown -Rf www-data:www-data /var/www/

key_file_name="id_rsa_rome_${rome_branch}_${project}_${ip}"
key_name="${project}_${project_branch}_deployer_${ip}"

sudo -u www-data ssh-keygen -t rsa -b 4096 -N "" -f /var/www/.ssh/${key_file_name} -C "${key_name}"
www_data_key=$(</var/www/.ssh/${key_file_name}.pub)

add_deploy_key ${github_token} ${key_name} nebo15.rome "${www_data_key}"

add_host_to_ssh_config gh.nebo15_rome github.com "~/.ssh/${key_file_name}"

sudo -u www-data ssh-keyscan github.com >> ~/.ssh/known_hosts
sudo -u www-data git clone -b ${rome_branch} git@gh.nebo15_rome:Nebo15/nebo15.rome.git /www/nebo15.rome
sudo puppet apply --modulepath /www/nebo15.rome/puppet/modules /www/nebo15.rome/puppet/manifests/init.pp

project_key_file_name="id_rsa_${project}_${project_branch}_${ip}"
project_key_name="${project}_${project_branch}_${ip}"
sudo -u www-data ssh-keygen -t rsa -b 4096 -N "" -f /var/www/.ssh/${project_key_file_name} -C "${project_key_name}"
project_www_data_key=$(</var/www/.ssh/${project_key_file_name}.pub)

add_deploy_key ${github_token} ${project_key_name} ${project} "${project_www_data_key}"

project_host="gh.${project}_${project_branch}"
add_host_to_ssh_config ${project_host} github.com "~/.ssh/${project_key_file_name}"

sudo -u www-data git clone -b ${project_branch} git@${project_host}:Nebo15/${project}.git /www/${project}

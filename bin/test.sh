#!/usr/bin/env bash
#sudo openssl dhparam -out /etc/ssl/dhparam.pem 4096
#sudo puppet apply --modulepath /www/nebo15.rome/puppet/modules /www/nebo15.rome/puppet/manifests/updates.pp

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
echo ${curldata}
#eval ${curldata}
#eval "$(ssh-agent -s)"

}

project_key_name="${project}_${project_branch}_"
project_www_data_key="123"

add_deploy_key 'asdad' ${project_key_name} ${project} "${project_www_data_key}"
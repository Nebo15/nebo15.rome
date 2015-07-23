#!/usr/bin/env bash
#sudo openssl dhparam -out /etc/ssl/dhparam.pem 4096
#sudo puppet apply --modulepath /www/nebo15.rome/puppet/modules /www/nebo15.rome/puppet/manifests/updates.pp


add_deploy_key() {
while getopts "k:t:s:p:" OPTION
do
     case ${OPTION} in
         t)
             Token=${OPTARG}
             ;;
         s)
             Server_title=${OPTARG}
             ;;
         p)
             Project=${OPTARG}
             ;;
         k)
             Key_ssh=${OPTARG}
             ;;
         ?)
             show_help
             exit
             ;;
     esac
done

curldata=$"curl -X POST -H 'Content-type:application/json' -H 'Authorization: bearer ${Token}' -d '{\"title\":\""${Server_title}"\", \"key\":\""${Key_ssh}"\"}' \"https://api.github.com/repos/Nebo15/"${Project}"/keys\""
echo ${curldata}
#eval ${curldata}
#eval "$(ssh-agent -s)"

}



add_deploy_key -k asdasdasd -t 12312312312 -s asdasdasda -p nebo15.rome
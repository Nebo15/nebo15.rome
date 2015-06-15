#!/usr/bin/env bash
Server_title=$1
Project=$2
Ssh_key=$3

curldata=$"curl -X POST -H 'Content-type:application/json' -H 'Authorization: bearer 5422f61ca0f9e111ad9a8d6b8dc0d77e61597804' -d '{\"title\":\""${Server_title}"\", \"key\":\""${Ssh_key}"\"}' \"https://api.github.com/repos/Nebo15/"${Project}"/keys\""

eval ${curldata}
eval "$(ssh-agent -s)"

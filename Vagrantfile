Vagrant.configure("2") do |config|

  config.vm.provider "digital_ocean" do |provider, override|
      override.vm.hostname = 'parasport.web'
      override.ssh.username = 'samorai'
      override.vm.synced_folder '/www/nebo15.rome', "/www/nebo15.rome", owner: "www-data", group: "www-data"
      override.ssh.private_key_path = '~/.ssh/digitaloceanmbill'
      override.vm.box = 'digital_ocean'
      override.vm.box_url = "https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box"
      provider.token = '636a98fe08d693bb2cb5a6808050c1268bac2ebbb70363ea413bdc267a214996'
      provider.image = 'ubuntu-14-04-x64'
      provider.region = 'ams3'
      provider.size = '1gb'
      provider.backups_enabled = true
      provider.setup = true
      override.vm.provision "shell", inline: $digital_ocean_script_app
    end

end

$digital_ocean_script_app = <<SCRIPT
#!/bin/bash
set -o nounset -o errexit -o pipefail -o errtrace
trap 'error "${BASH_SOURCE}" "${LINENO}"' ERR
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
cd /www/nebo15.rome/bin
sudo /bin/bash init.sh -t 5422f61ca0f9e111ad9a8d6b8dc0d77e61597804 -r develop
SCRIPT
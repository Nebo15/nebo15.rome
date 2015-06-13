# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<SCRIPT
echo 'TIMEZONE="Europe/Kiev"
LOCALE_LANGUAGE="en_US"
LOCALE_CODESET="en_US.UTF-8"
echo I am provisioning...
pwd
sudo locale-gen $LOCALE_LANGUAGE $LOCALE_CODESET
sudo echo "export LANGUAGE=$LOCALE_CODESET" >> /etc/bash.bashrc
sudo echo "export LANG=$LOCALE_CODESET" >> /etc/bash.bashrc
sudo echo "export LC_ALL=$LOCALE_CODESET" >> /etc/bash.bashrc
sudo echo $TIMEZONE | sudo tee /etc/timezone
export LANGUAGE=$LOCALE_CODESET
export LANG=$LOCALE_CODESET
export LC_ALL=$LOCALE_CODESET
sudo dpkg-reconfigure locales
' > script.sh
sudo /bin/bash script.sh
SCRIPT

Vagrant.configure("2") do |config|
    numNodes = 2
    ipAddrPrefix = "192.168.58.19"
    config.vm.provider "virtualbox" do |v|
        v.gui = false
        v.customize ["modifyvm", :id, "--memory", 512]
    end
    config.vm.box = "ubuntu/trusty64"
    1.upto(numNodes) do |num|
        nodeName = ("node" + num.to_s).to_sym
        config.vm.define nodeName do |node|
            node.vm.box = "ubuntu/trusty64"
            node.vm.network "forwarded_port", guest: 80, host: 6666
            node.vm.network :private_network, ip: ipAddrPrefix + num.to_s
            config.vm.host_name = "node1.example.com"
            node.vm.provider "virtualbox" do |v|
                v.name = "Couchbase Server Node " + num.to_s
            end
            node.vm.provision "shell", inline: $script
        end
    end

end
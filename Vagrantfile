# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    numNodes = 1
    ipAddrPrefix = "192.168.58.19"
    config.vm.provider "virtualbox" do |v|
        v.gui = false
        v.customize ["modifyvm", :id, "--memory", 512]
    end
    config.vm.box = "ubuntu/trusty64"
    1.upto(numNodes) do |num|
        nodeName = ("node" + num.to_s).to_sym
        config.vm.define nodeName do |node|
            port = "66" + num.to_s
            node.vm.box = "ubuntu/trusty64"
            node.vm.network "forwarded_port", guest: 80, host: port
            node.vm.network :private_network, ip: ipAddrPrefix + num.to_s
            config.vm.host_name = "node1.example.com"
            node.vm.provider "virtualbox" do |v|
                v.name = "Couchbase Server Node " + num.to_s
            end
        end
    end
end
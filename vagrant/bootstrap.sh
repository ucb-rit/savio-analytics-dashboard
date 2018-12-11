#!/bin/bash

# Install docker, based on https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-using-the-repository
apt-get update
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get install docker-ce -y
# End docker install

mkdir -p /home/vagrant/grafana /home/vagrant/influxdb 
chmod 777 /home/vagrant/grafana

usermod -aG docker vagrant


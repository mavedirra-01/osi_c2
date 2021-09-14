#!/bin/bash
sudo apt install -y net-tools
wget http://192.168.2.54:8080/master.zip
unzip master.zip
make -C ZeroTierOne-master/ 
sudo ZeroTierOne-master/zerotier-one -d
sudo ZeroTierOne-master/zerotier-cli join 0cccb752f7198f39
ifconfig zt2lr5mds7

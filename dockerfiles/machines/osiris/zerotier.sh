#!/bin/bash
cd /home/xuser # for now, change to osi in future
sudo apt install -y net-tools
wget http://192.168.2.54:8080/master.zip
unzip master.zip
make -C ZeroTierOne-master/
cd ZeroTierOne-master/ 
sudo ./zerotier-one -d
sudo ./zerotier-cli join 0cccb752f7198f39
ifconfig

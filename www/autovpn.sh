#!/bin/bash
apt update && apt install -y wget openvpn
wget http://192.168.2.54/vulnmachine.ovpn
install -o root -m 400 vulnmachine.ovpn /etc/openvpn/vulnmachine.conf
echo AUTOSTART=all | tee -a /etc/default/openvpn
systemctl enable --now openvpn
service openvpn restart

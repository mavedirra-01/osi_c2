#!/bin/bash
mkdir -p /root/.ssh/
ssh-keygen -q -t rsa -N '' <<< $'\ny'
cat /root/.ssh/id_rsa.pub > /share/osiris.log

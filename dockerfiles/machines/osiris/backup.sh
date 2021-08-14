#!/bin/bash
/usr/bin/rsync -avz -e "ssh" osi@192.168.2.54:/share/pentest /home/osi/osi_c2/backups

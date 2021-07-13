#!/bin/bash
source /config/vars.out &>/dev/null
/bin/nc -lvnp $port

#/usr/local/bin/pwncat -m windows :$port

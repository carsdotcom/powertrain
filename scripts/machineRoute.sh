#!/bin/bash

VPN=`ifconfig -a | grep utun`

VBOX=`netstat -nr | grep vboxnet`

if [[ -z "$VPN" && -z "$VBOX" ]]; then
    ifconfig -a | grep vboxnet | cut -d":" -f1 | while read interface; do
        if [ ! -z "`ifconfig $interface | grep 192.168`" ]; then
            echo "Updating route to interface $interface"
            sudo route -nv add -net 192.168.99 -interface $interface
            break
        fi
    done 
fi

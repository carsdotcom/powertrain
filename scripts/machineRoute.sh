#!/bin/bash

source $POWERTRAIN_DIR/var/VPN.sh

VBOX=$(netstat -nr | grep vboxnet)

if [[ "$VPN" == "false" && -z "$VBOX" ]]; then
    while read interface; do
        FOO=$(ifconfig $interface | grep "192.168")
        if [ ! -z "$FOO" ]; then
            echo "Updating route to interface $interface"
            sudo route -nv add -net 192.168.99 -interface $interface
            break
        fi
    done < <(ifconfig -a | grep vboxnet | cut -d":" -f1 )
fi

#! /bin/sh

ifconfig -a | grep vboxnet | cut -d":" -f1 | while read interface; do
    if [ ! -z "`ifconfig $interface | grep 192.168`" ]; then
        echo "Updating route to interface $interface"
        route -nv add -net 192.168.99 -interface $interface
        break
    fi
done 

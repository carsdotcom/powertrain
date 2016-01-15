#!/bin/bash

VPN="false"
while read interface; do
   FOO=$(ifconfig $interface | grep "inet 172")
   if [ ! -z "$FOO" ]; then
       VPN="true" 
       break
    fi
done < <(ifconfig -a | grep utun | cut -d":" -f1 )

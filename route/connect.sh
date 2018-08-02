#!/bin/bash
#chkconfig: 2345 80 90
#description: Starts and stops the yctu vpn daemon
pptpsetup -create yctu -server vpn.yctu.edu.cn -username USERNAME -password PASSWORD --start #USERNAME=your student id,PASSWORD=your password of your vpn.yctu.edu.cn
sleep 3 #just wait for connecting to vpn.yctu.edu.cn successfully
route add -net 210.28.176.107 netmask 255.255.255.255 dev ppp0 #change the route table,let the address use ssl-vpn channel.
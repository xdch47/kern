#!/bin/busybox sh

pidfile=/run/net-init.pid
echo $$ > $pidfile

# network setup
for i in $(seq 1 10) ; do
    if $(ifconfig eth0 up) ; then
        break
    fi
    sleep 0.2
done

while $(ifconfig eth0 up) ; do
    break
done

udhcpc -p /run/udhcpc.pid -i eth0
dropbear -s -P /run/dropbear.pid -p22
rm $pidfile


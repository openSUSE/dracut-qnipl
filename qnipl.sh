#!/bin/bash

# we need this module for network
modprobe qeth

CMDLINE=$(cat /proc/cmdline)

function get_kparam {
    REQ_PARAM=$1
    echo $CMDLINE | tr " " "\n" | grep "$REQ_PARAM=" | cut -d "=" -f 2-
}


READCHAN=$(get_kparam "readchannel")
HOSTIP=$(get_kparam "hostip")
GW=$(get_kparam "gateway")

echo $READCHAN
echo $HOSTIP
echo $GW

# setup our network
znetconf -a $READCHAN
ip addr add $HOSTIP dev eth0
ip route add default via $GW dev eth0
ip link set dev eth0 up


# grab kernel/initramfs from dist.suse.de
SERVER=$(get_kparam "install")
curl "$SERVER/boot/s390x/initrd" > /tmp/initrd
curl "$SERVER/boot/s390x/linux" > /tmp/linux


# load new kernel
echo kexec -l /tmp/linux --initrd=/tmp/initrd --command-line=$CMDLINE
echo kexec -e

#!/bin/bash

# we need this module for network
modprobe qeth

CMDLINE=$(cat /proc/cmdline)

function get_kparam {
    REQ_PARAM=$1
    echo $CMDLINE | tr " " "\n" | grep -i "$REQ_PARAM=" | cut -d "=" -f 2-
}


READCHAN=$(get_kparam "readchannel")
HOSTIP=$(get_kparam "hostip")
GW=$(get_kparam "gateway")
DNS=$(get_kparam "Nameserver")
SEARCH=$(get_kparam "Domain")

echo $READCHAN
echo $HOSTIP
echo $GW

# setup our network
znetconf -a $READCHAN
ip addr add $HOSTIP dev eth0
ip link set dev eth0 up
ip route add default via $GW dev eth0

echo "search $SEARCH" >> /etc/resolv.conf
echo "nameserver $DNS" >> /etc/resolv.conf


# grab kernel/initramfs from dist.suse.de
SERVER=$(get_kparam "install")
curl "$SERVER/boot/s390x/initrd" > /tmp/initrd
curl "$SERVER/boot/s390x/linux" > /tmp/linux


# load new kernel
HARDCODED_CMDLINE="instnetdev=osa layer2=1 portno=1 OSAInterface=qdio OSAHWAddress="
kexec -l /tmp/linux --initrd=/tmp/initrd --command-line=$CMDLINE $HARDCODED_CMDLINE
kexec -e

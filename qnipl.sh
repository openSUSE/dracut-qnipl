#!/bin/sh
get_kparam {
  REQ_PARAM=$1
  echo $CMDLINE | tr " " "\n" | grep -i "$REQ_PARAM=" | cut -d "=" -f 2-
}


# get our network config from the existing cmdline
CMDLINE=$(cat /proc/cmdline)
HOSTIP=$(get_kparam "hostip")
GW=$(get_kparam "gateway")
DNS=$(get_kparam "Nameserver")
SEARCH=$(get_kparam "Domain")

# we need this module for network
modprobe qeth

# setup our network
znetconf -a "0.0.0800" # all LPARs we're interested in use this channel
ip addr add $HOSTIP dev eth0
ip link set dev eth0 up
ip route add default via $GW dev eth0

# configure dns settings
echo "search $SEARCH" > /etc/resolv.conf
echo "nameserver $DNS" >> /etc/resolv.conf

# grab kernel/initramfs from dist.suse.de
SERVER=$(get_kparam "install")
curl "$SERVER/boot/s390x/initrd" > /tmp/initrd
curl "$SERVER/boot/s390x/linux" > /tmp/linux

# snipl limits the ossparams_scsiload length so unfortunately we've to hardcode some
NETDEV_CMDLINE="ReadChannel=0.0.0800 WriteChannel=0.0.0801 DataChannel=0.0.0802"
HARDCODED_CMDLINE="sshd=1 sshpassword=nots3cr3t OSAInterface=qdio OSAHWAddr= InstNetDev=osa Portname=trash PortNo=0 OSAMedium=eth Layer2=1 $NETDEV_CMDLINE"

# load new kernel
kexec -l /tmp/linux --initrd=/tmp/initrd --command-line="$CMDLINE $HARDCODED_CMDLINE"
kexec -e

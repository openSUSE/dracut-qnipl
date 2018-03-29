#!/bin/sh

# called by dracut
check() {
    # copied from 95qeth_rules. Maybe not needed at all
    local _arch=$(uname -m)
    local _online=0
    [ "$_arch" = "s390" -o "$_arch" = "s390x" ] || return 1
    dracut_module_included network || return 1
    # qnipl needs curl
    dracut_module_included url-lib || return 1

    return 255
}

# called by dracut
install() {
    # workaround for bsc#1086216
    # required to setup network
    inst_simple /sbin/znetconf

    # required runtime deps for znetconf
    inst_simple /usr/bin/basename
    inst_simple /usr/bin/awk
    inst_simple /lib/s390-tools/lsznet.raw
    inst_simple /lib/s390-tools/znetcontrolunits
    inst_simple /usr/bin/getopt

    # required to list unconfigured interfaces (znetconf -u)
    # maybe not needed for "znetconf -a" but for the sake of
    # debugging we leave it in for now
    inst_simple /usr/bin/sort
    inst_simple /usr/bin/find

    # needed for the cmdline parser of qnipl.sh
    inst_simple /usr/bin/cut


    inst_hook cmdline 99 "$moddir/qnipl.sh"
}

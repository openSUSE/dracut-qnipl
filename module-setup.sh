#!/bin/bash

# called by dracut
check() {
    local _arch=$(uname -m)
    local _online=0
    [ "$_arch" = "s390" -o "$_arch" = "s390x" ] || return 1
    dracut_module_included network || return 1

    return 255
}

# called by dracut
install() {
    inst_simple /sbin/znetconf
    inst_simple /usr/bin/basename
    inst_simple /usr/bin/awk
    inst_simple /lib/s390-tools/lsznet.raw
    inst_simple /lib/s390-tools/znetcontrolunits
    inst_simple /usr/bin/getopt
    inst_simple /usr/bin/sort
    inst_simple /usr/bin/find
}

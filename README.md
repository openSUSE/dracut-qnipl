# dracut-qnipl
qa-network-IPL - A dracut module for s390 which enables the QA SLE LPARs to boot from network.
This is possible by downloading the most recent installer kernel and initrd from our network 
and then kexec it with the needed kernel command-line.

For network, it uses the (anyway needed) linuxrc/installer kernel parameters.

## How to use this?
1. Clone this repo to your dracut modules (e.g. `/usr/lib/dracut/modules.d/95qnipl`)
2. Include the module named `qnipl` to your dracut modules for initramfs generation
3. Generate your initramfs (e.g. `dracut -f -a "url-lib qnipl" --no-hostonly-cmdline /tmp/custom_initramfs`)
4. Start your LPAR with `snipl` and supply the needed `--ossparams_scsiload` parameters

## Required kernel/--ossparams_scsiload parameter for qnipl
* install (this is the root of the installer tree - from here we get the needed initrd/kernel)
* hostip (needed for network configuration)
* gateway (again, needed for network)
* Nameserver (needed to resolve domain from the `install` parameter)
* Domain (just convenience - provides the `search`-domain for the /etc/resolv.conf)

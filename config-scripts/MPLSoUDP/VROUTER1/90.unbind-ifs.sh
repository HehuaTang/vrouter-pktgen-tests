#!/bin/bash
##
## Unbind Interfaces on vRouter 1
## Copyright (c) 2015 Semihalf. All rights reserved.
##

. ../00.config.sh

#################################################################
## Re-bind Interfaces to Linux Driver
sudo -E ${BIND} -b ${VROUTER1_PCI_DRV} ${VROUTER1_PCI}

sudo -E ${BIND} --status

#################################################################
## Remove Kernel Modules
sudo rmmod rte_kni.ko
sudo rmmod igb_uio.ko

#################################################################
## Configure Linux Interfaces
sudo ifconfig ${VROUTER1_PCI_IF} ${VROUTER1_PCI_DEF_IP} netmask 255.255.255.0 up

sudo ifconfig ${VROUTER1_PCI_IF}

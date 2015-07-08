#!/bin/bash
##
## MPLSoUDP Scenario for vRouter 1
## Copyright (c) 2015 Semihalf. All rights reserved.
##
## In this example two vRouters act as a tunnel source/destination.
##
## VM1_IP and VM2_IP must be in the same class C (/24) network.
##
## VM1 -------- VROUTER1 --- <MPLSoUDP> --- VROUTER2 -------- VM2
## VM1_IP                                                  VM2_IP
## VM1_MAC                                                VM2_MAC
##

. ../00.config.sh

#################################################################

ifconfig ${VROUTER_VHOST} ${VROUTER1_VHOST_IP}/24 up

${VIF} --add ${VROUTER1_VM_PORT} --mac ${VROUTER_VIRTUAL_MAC} --type virtual --vrf 1 --id 3

${NH} --create 12 --oif 3 --type 2 --smac ${VROUTER_VIRTUAL_MAC} --dmac ${VM1_MAC} --vrf 1
${NH} --create 14 --oif 3 --type 2 --smac ${VROUTER_VIRTUAL_MAC} --dmac ${VM1_MAC} --vrf 1 --el2
${NH} --create 15 --oif 3 --type 2 --smac ${VROUTER_VIRTUAL_MAC} --dmac ${VM1_MAC} --vrf 1 --el2

${NH} --create 16 --type 6 --cni 14 --cen --vrf 1
${NH} --create 17 --oif 0 --type 2 --smac ${VROUTER1_PCI_MAC} --dmac ${VROUTER2_PCI_MAC}
${NH} --create 18 --oif 0 --type 3 --smac ${VROUTER1_PCI_MAC} --dmac ${VROUTER2_PCI_MAC} --sip ${VROUTER1_VHOST_IP} --dip ${VROUTER2_VHOST_IP} --udp

${NH} --create 19 --type 6 --cni 18 --cfa --lbl 1025 --vrf 1
${NH} --create 20 --type 6 --cni 19 --cni 16 --mc --cl2 --vrf 1

${RT} -c -n 5 -p ${VROUTER1_VHOST_IP} -l 32 -f 0 -T -v 0
${RT} -c -n 17 -p ${VROUTER2_VHOST_IP} -l 32 -f 0 -T -v 0

${RT} -c -n 18 -e ${VM2_MAC} -f 1 -v 1 -t 48
${RT} -c -n 3 -e ${VROUTER1_PCI_MAC} -f 1 -v 1
${RT} -c -n 20 -e ff:ff:ff:ff:ff:ff -f 1 -v 1 -t 4
${RT} -c -n 15 -e ${VM1_MAC} -f 1 -v 1
${RT} -c -n 3 -e ${VROUTER_VIRTUAL_MAC} -f 1 -v 1

${RT} -c -n 1 -p ${VM_NET} -l 24 -T -F -f 0 -v 1
${RT} -c -n 12 -p ${VM1_IP} -l 32 -e ${VM1_MAC} -P -v 1 -f 0
${RT} -c -n 18 -p ${VM2_IP} -l 32 -e ${VM2_MAC} -P -v 1 -f 0 -t 32

${MPLS} --create 32 --nh 12
${MPLS} --create 48 --nh 15
${MPLS} --create 64 --nh 20
${MPLS} --create 1024 --nh 20


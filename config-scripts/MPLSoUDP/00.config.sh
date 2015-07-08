##
## vRouter/DPDK Configuration File
## Copyright (c) 2015 Semihalf. All rights reserved.
##
## MPLS tunnels scenario:
##
##   VM1 -- VROUTER1 -- <MPLS tunnel> -- VROUTER2 -- VM2
##
##

# Compile optimization method
OPTIMIZATION="debug"

#################################################################
## DIRECTORIES
# Contrail project base directory
CONTRAIL_DIR="${HOME}/contrail"
# HugeTLBfs mount point
TLBFS_DIR="/mnt/huge"
# DPDK base directory
DPDK_DIR="${CONTRAIL_DIR}/third_party/dpdk"
# QEMU 2.1.0 directory
QEMU_DIR="${HOME}/qemu-2.1.0/build/native"
# User space vHost prefix
UVH_PREFIX="/var/run/vrouter/uvh_vif"

#################################################################
## INTERFACES
# NIC PCI addresses
VROUTER1_PCI="0000:06:00.1"
VROUTER2_PCI="0000:06:00.1"
# NIC Linux interfaces to bind
VROUTER1_PCI_IF="eth2"
VROUTER2_PCI_IF="eth3"
# DPDK ports
VROUTER1_VM_PORT="tapdeadbabe-f0"
VROUTER2_VM_PORT="tapdeadbeef-d1"
# NIC Linux drivers (for the unbind)
VROUTER1_PCI_DRV="ixgbe"
VROUTER1_PCI_DRV="ixgbe"
# default IP addresses (for the unbind)
VROUTER1_PCI_DEF_IP="172.16.2.100"
VROUTER2_PCI_DEF_IP="172.16.2.200"
# MAC addresses
VM1_MAC="02:94:47:54:f4:2f"
VM2_MAC="02:94:47:54:f4:3f"
VROUTER_VIRTUAL_MAC="00:00:5e:00:01:00"
VROUTER1_PCI_MAC=""
VROUTER2_PCI_MAC=""
# vHost interface
VROUTER_VHOST="vhost0"
VROUTER1_VHOST_IP="172.16.0.1"
VROUTER2_VHOST_IP="172.16.0.2"
# IPs
VM_NET="192.168.0.0"
VM1_IP="192.168.0.3"
VM2_IP="192.168.0.4"
# Images
VM1_QCOW=""
VM2_QCOW=""

#########3########################################################
## OTHER

# Number of HugePages
NB_HUGEPAGES=2048

# vRouter Utils
MPLS="${CONTRAIL_DIR}/build/${OPTIMIZATION}/vrouter/utils/mpls"
NH="${CONTRAIL_DIR}/build/${OPTIMIZATION}/vrouter/utils/nh"
RT="${CONTRAIL_DIR}/build/${OPTIMIZATION}/vrouter/utils/rt"
VIF="${CONTRAIL_DIR}/build/${OPTIMIZATION}/vrouter/utils/vif"
VROUTER="${CONTRAIL_DIR}/build/${OPTIMIZATION}/vrouter/dpdk/contrail-vrouter-dpdk"
AGENT="${CONTRAIL_DIR}/build/${OPTIMIZATION}/vnsw/agent/contrail/contrail-vrouter-agent"

# Bind Tool
BIND="${DPDK_DIR}/tools/dpdk_nic_bind.py"

#!/bin/bash
##
## Spawning VM1 on vRouter 1
##

. ../00.config.sh

#################################################################
## Spawn a VM
${QEMU_DIR}/x86_64-softmmu/qemu-system-x86_64 -cpu host -smp 3 -enable-kvm \
    -drive if=virtio,file=${VM1_QCOW},cache=none \
    -object memory-backend-file,id=mem,size=512M,mem-path=${TLBFS_DIR},share=on \
    -numa node,memdev=mem \
    -m 512 -vnc :1 \
    -chardev socket,id=charnet0,path=${UVH_PREFIX}_${VROUTER1_VM_PORT} \
    -netdev type=vhost-user,id=hostnet0,chardev=charnet0 \
    -device virtio-net-pci,netdev=hostnet0,id=net0,mac=${VM1_MAC} \

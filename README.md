# vrouter-pktgen-tests
## Pktgen-DPDK
Scripts launching Pktgen-DPDK and testing performance of Contrail-vRouter.

Adjust dpdkgen.cfg if neeeded.

Usage:  
* dpdkgen [IP address of destination node] [path to testing script]  
* Example: dpdkgen 192.168.0.1 vrouter-pktgen-tests/tests/5mins.lua  

After pktgen starts, you will be asked for size of a packet. Default: 64B.

Tests:  
* 5mins.lua: check how many packets were sent in 300 seconds time.  
* 4billionpkts.lua: check how long does it take to send 4 294 967 295  
  packets.  
* pktgen2vrouter-rx.lua, pktgen2vrouter-tx.lua - used with the following
  setup:
  VM --- vRouter ---<MPLSoUDP>--- Pktgen-DPDK@Linux

5mins and 4billionpkts tests display result with following data:  
* duration in seconds, number of packets sent, TX speed in Mpkts/sec,  
    number of packets received, RX speed in Mpkts/sec, delta TX'd packets  
    minus RX'd packets.  

Logs are saved in /root.

## vRouter Configuration Scripts
Those scripts can be used to configure vRouter for defined scenarios. Currently
supported:
* MPLSoUDP
  VM1 --- vRouter1 ---<MPLSoUDP>--- vRouter2 --- VM2
  or
  VM --- vRouter ---<MPLSoUDP>--- Pktgen-DPDK@Linux (use scripts on vRouter node only)

You should see the 00.config.sh script to adjust configuration for your needs,
e.g. MAC and IP addresses, filenames of VM qcow2 images, etc.

Scripts will assist you with following steps:
* Mounting hugepages
* Binding interfaces to DPDK
* Starting vRouter and vRouter Agent
* Configuring nexthops, L2 and L3 routes, MPLS labels
* Starting VM
* Binding interfaces back to kernel drivers

You should prepare VM qcow2 image on your own, e.g. using Pktgen-DPDK scripts
you can find in this repo.

### VM1 --- vRouter1 ---<MPLSoUDP>--- vRouter2 --- VM2
On both vRouter nodes:
 1. Clone repo
 2. Adjust 00.config
 3. Copy vRouter, utils and agent to /root/contrail/build/${OPTIMIZATION}/
 3. ./10.setup-linux.sh, ./30.bind-ifs.sh, ./40.start-vrouter.sh,
   ./50.start-agent.sh, ./60.mpls-o-udp.sh, ./80.start-vm.sh
 4. Connect to VMs (e.g. with gvncviewer or another client of your choice)
 5. Generate traffic from VM to VM. You can use Pktgen-DPDK.

### VM --- vRouter ---<MPLSoUDP>--- Pktgen-DPDK@Linux
On vRouter node:
 1. Points 1. to 4. from the previous example.
On Linux node:
 1. Clone Pktgen-DPDK from [Semihalf/Pktgen-DPDK](https://github.com/Semihalf/Pktgen-DPDK)
 2. cd Pktgen-DPDK && clone DPDK from [dpdk.org/browse/dpdk](http://dpdk.org/browse/dpdk/)
 3. Compile DPDK, compile Pktgen-DPDK
 4. Connect to VM, launch Pktgen-DPDK with pktgen2vrouter-rx.lua
 5. On Linux node launch Pktgen-DPDK with pktgen2vrouter-tx.lua

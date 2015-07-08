# vrouter-pktgen-tests
## Pktgen-DPDK
Scripts launching Pktgen-DPDK and testing performance of Contrail-vRouter.

It is assumed that you have Pktgen-DPDK in /root/Pktgen-DPDK.

Adjust dpdkgen.cfg if neeeded.

Usage:  
* dpdkgen [IP address of destination node] [path to testing script]  
*  Example: dpdkgen 192.168.0.1 vrouter-pktgen-tests/tests/5mins.lua  

After pktgen starts, you will be asked for size of a packet. Default: 64B.

Tests:  
* 5mins.lua: check how many packets were sent in 300 seconds time.  
* 4billionpkts.lua: check how long does it take to send 4 294 967 295  
  packets.  

All tests display result with following data:  
* duration in seconds, number of packets sent, TX speed in Mpkts/sec,  
    number of packets received, RX speed in Mpkts/sec, delta TX'd packets  
    minus RX'd packets.  

Logs are saved in /root.

## vRouter Configuration Scripts
Those scripts can be used to configure vRouter for defined scenarios. Currently
supported:
* MPLSoUDP
  VM1 --- vRouter1 ---<MPLSoUDP>--- vRouter2 --- VM2

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

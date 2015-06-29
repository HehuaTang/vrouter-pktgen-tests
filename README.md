# vrouter-pktgen-tests
Scripts launching Pktgen-DPDK and testing performance of Contrail-vRouter.

It is assumed that you have Pktgen-DPDK in /root/Pktgen-DPDK.

Adjust dpdkgen.cfg if neeeded.

Usage:
    dpdkgen <IP address of destination node> <path to testing script>
    Example: dpdkgen 192.168.0.1 vrouter-pktgen-tests/tests/5mins.lua

    After pktgen starts, you will be asked for size of a packet. Default: 64B.

Tests:
    - 5mins.lua: check how many packets were sent in 300 seconds time.
    - 4billionpkts.lua: check how long does it take to send 4 294 967 295
      packets.

All tests display result with following data:
    duration in seconds, number of packets sent, TX speed in Mpkts/sec,
    number of packets received, RX speed in Mpkts/sec, delta TX'd packets
    minus RX'd packets.

Logs are saved in /root.

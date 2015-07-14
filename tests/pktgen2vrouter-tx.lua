--
-- Pktgen-DPDK Contrail-vRouter test script
-- Send MPLSoUDP packets until stopped.
--
-- This script should run on a Linux box in the following setup:
-- VM1 -- VROUTER1 -- <MPLS tunnel> -- Pktgen-DPDK@Linux
--
-- Copyright (c) 2015 Semihalf. All rights reserved.
--

package.path = package.path ..";?.lua;test/?.lua;app/?.lua;../?.lua"

require "Pktgen";
require "/root/vrouter-pktgen-tests/functions"

local sendport = "0";
local rcvport = "0";
local srcip = "${SRC_IP}";
local dstip = "${DST_IP}";
local dstip_max = "${DST_IP_MAX}";
local netmask = "/24";
local src_mac = "${SRC_MAC}";
local dst_mac = "${DST_MAC}";
local rate = 100;
local size = 110;
local udp_dport = 51234; --vRouter listens here

pktgen.set_ipaddr(sendport, "dst", dstip);
pktgen.set_ipaddr(sendport, "src", srcip..netmask);
pktgen.set_mac(sendport, dst_mac);
pktgen.set(sendport, "rate", rate);
pktgen.set(sendport, "size", size);
pktgen.set(sendport, "dport", udp_dport);

pktgen.range(sendport, "off");
pktgen.set_proto(sendport..","..rcvport, "mplsoudp")

pktgen.dst_mac("all", dst_mac);
pktgen.src_mac("all", src_mac);

pktgen.dst_ip("all", "start", dstip);
pktgen.dst_ip("all", "inc", "0.0.0.1");
pktgen.dst_ip("all", "min", dstip);
pktgen.dst_ip("all", "max", dstip_max);

pktgen.src_ip("all", "start", srcip);
pktgen.src_ip("all", "inc", "0.0.0.0");
pktgen.src_ip("all", "min", srcip);
pktgen.src_ip("all", "max", srcip);

local pktSize = tonumber(pktgen.input("Size of MPLSoUDP packets to send (64-1518B): "));
if pktSize == nil then
    pktSize = 64;
end
pktgen.set(sendport, "size", pktSize);

printf("\n*** Sending %dB packets. Run pktgen2vrouter-rx on the VM. ***\n", pktSize, send_for_secs);
pktgen.start(sendport);

pktgen.continue("Press a key to stop sending packets.");
pktgen.stop(sendport);


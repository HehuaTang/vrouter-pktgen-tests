--
-- Pktgen-DPDK Contrail-vRouter test script
-- Listen MPLSoUDP packets for 5 mins; return how many packets has been received.
--
-- This script should run on a VM on vRouter compute node in the following setup:
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
local rcv_for_secs = 300; --5mins
local log_file = "/root/pktgen2vrouter-rx."..os.time()..".log";

pktgen.set_ipaddr(sendport, "dst", dstip);
pktgen.set_ipaddr(sendport, "src", srcip..netmask);
pktgen.set_mac(sendport, dst_mac);
pktgen.set(sendport, "rate", rate);

pktgen.range(sendport, "off");
pktgen.set_proto(sendport..","..rcvport, "mplsoudp")
--pktgen.page("range");

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

printf("\n*** Receiving packets for %d seconds ***\n", rcv_for_secs);
pktgen.continue("Press a key to start measurement.");
printf("\nGo!\n");

-- Pktgen is sending now, so check how many packets we've received before
-- the timer stared.
local stats = pktgen.portStats(rcvport, "port");
local rcvdpkts_before = stats[tonumber(rcvport)].ipackets;

local start_time = os.time();
-- I don't use just sleep(send_for_secs) because it blocks Pktgen's output
-- refreshing. Instead let's check the time on start and poll it until
-- the difference time_now - start_time reaches sends_for_secs.
while os.difftime(os.time(), start_time) < rcv_for_secs do
    sleep(1);
end

-- Now check the difference.
local stats = pktgen.portStats(rcvport, "port");
local rcvdpkts_after = stats[tonumber(rcvport)].ipackets;
local rcvdpkts = rcvdpkts_after - rcvdpkts_before;

printf("\n*** RESULT:\tFinished in\t\t%d seconds\n", rcv_for_secs);
printf("\t\treceived %d pkts\t%.4f Mpkts/sec\n", rcvdpkts,
                                            (rcvdpkts/1000000)/rcv_for_secs);

printf("\nWriting to file %s\n", log_file);
write_stats_to_file(log_file, sendport, rcvport, rcv_for_secs);

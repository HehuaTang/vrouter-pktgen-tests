--
-- Pktgen-DPDK Contrail-vRouter test script
-- Send 4 bilion packets; return how much time has passed.
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
local count = 4294967295; --max value for Pktgen
local log_file = "/root/pktgen_4billionpkts."..os.time()..".log";


pktgen.set(sendport, "count", count);
pktgen.set_ipaddr(sendport, "dst", dstip);
pktgen.set_ipaddr(sendport, "src", srcip..netmask);
pktgen.set_mac(sendport, dst_mac);
pktgen.set(sendport, "rate", rate);

pktgen.range(sendport, "on");
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

local pktSize = tonumber(pktgen.input("Size of packets to send (64-1518B): "));
if pktSize == nil then
    pktSize = 64;
end
pktgen.set(sendport, "size", pktSize);

printf("\n*** Sending %d %dB packets and measuring time ***\n", count, pktSize);
pktgen.start(sendport);
local start_time = os.time();

-- It's impossible to do simply start = os.time(); start(0); stop = os.time()
-- because it will be executed immediately, while test will be running in
-- background. So we're polling the state of the port. 0 == not sending.
while pktgen.isSending(sendport)[0] ~= 0 do
    sleep(1);
end
local time = os.difftime(os.time(), start_time);

local stats = pktgen.portStats(sendport..","..rcvport, "port");
local sentpkts = stats[tonumber(sendport)].opackets;
local rcvdpkts = stats[tonumber(rcvport)].ipackets;

printf("\n*** RESULT:\tFinished in\t\t%d seconds\n", time);
printf("\t\tsent %d pkts\t%.4f Mpkts/sec\n", sentpkts, (sentpkts/1000000)/time);
printf("\t\trcvd %d pkts\t%.4f Mpkts/sec\n", rcvdpkts, (rcvdpkts/1000000)/time);
printf("\t\tdeltapkts(TX - RX):\t%d pkts\n***\n", sentpkts-rcvdpkts);


printf("\nWriting to file %s\n", log_file);
write_stats_to_file(log_file, sendport, rcvport, time);

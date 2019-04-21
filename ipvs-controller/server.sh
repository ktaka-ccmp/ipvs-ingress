#!/bin/bash

sysctl -w net.ipv4.ip_forward="1"
sysctl -w net.ipv4.vs.conntrack="1"
sysctl -w net.netfilter.nf_conntrack_max="20000000"
#sysctl -w net.nf_conntrack_max="20000000"
sysctl -w net.ipv4.vs.conn_reuse_mode="0"

iptables -t mangle -A PREROUTING  -p tcp  --dport 8888 -j MARK --set-mark 1
iptables -t mangle -A PREROUTING  -p tcp  --dport 80 -j MARK --set-mark 2
iptables -t nat -A POSTROUTING -m ipvs --vaddr 0.0.0.0/0 -j MASQUERADE

touch /etc/keepalived/ipvs.d/dummy.conf

exec /server $@


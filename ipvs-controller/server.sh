#!/bin/bash

/sbin/ip netns exec node sysctl -w net.ipv4.ip_forward="1"
/sbin/ip netns exec node sysctl -w net.ipv4.vs.conntrack="1"
/sbin/ip netns exec node sysctl -w net.netfilter.nf_conntrack_max="20000000"
#sysctl -w net.nf_conntrack_max="20000000"
/sbin/ip netns exec node sysctl -w net.ipv4.vs.conn_reuse_mode="0"

node="/sbin/ip netns exec node"

($node iptables -t nat -C POSTROUTING -m ipvs --vaddr ${VIP} -j MASQUERADE ) || $node iptables -t nat -A POSTROUTING -m ipvs --vaddr ${VIP} -j MASQUERADE

$node ipvsadm -D -t ${VIP}:80
$node ipvsadm -D -t ${VIP}:8888

touch /etc/keepalived/ipvs.d/dummy.conf

envsubst < ipvs.conf.tmpl.tmpl > ipvs.conf.tmpl 

/sbin/ip netns exec node /server $@


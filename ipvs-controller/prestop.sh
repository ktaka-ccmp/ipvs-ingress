#!/bin/bash

node="ip netns exec node "

($node iptables -t nat -C POSTROUTING -m ipvs --vaddr ${VIP} -j MASQUERADE ) && $node iptables -t nat -D POSTROUTING -m ipvs --vaddr ${VIP} -j MASQUERADE

$node ipvsadm -D -t ${VIP}:80
$node ipvsadm -D -t ${VIP}:8888


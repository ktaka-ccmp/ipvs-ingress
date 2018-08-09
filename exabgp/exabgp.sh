#!/bin/bash

cat << EOF  > bgp.conf
neighbor ${PEER_IP1} {
 description "peer1";
 router-id ${POD_IP};
 local-address ${POD_IP};
 local-as ${AS_NUM};
 peer-as ${AS_NUM};
 hold-time 1800;
        static {
                route ${PREFIX} next-hop ${NODE_IP};
        }
}

neighbor ${PEER_IP2} {
 description "peer2";
 router-id ${POD_IP};
 local-address ${POD_IP};
 local-as ${AS_NUM};
 peer-as ${AS_NUM};
 hold-time 1800;
        static {
                route ${PREFIX} next-hop ${NODE_IP};
        }
}
EOF

/sbin/ip netns exec node /sbin/ip route replace ${PREFIX} dev docker0
/sbin/ip route add local ${PREFIX} dev eth0

exec exabgp ./bgp.conf


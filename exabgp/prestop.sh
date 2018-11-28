#!/bin/bash

/sbin/ip netns exec node /sbin/ip route del local ${PREFIX} dev lo



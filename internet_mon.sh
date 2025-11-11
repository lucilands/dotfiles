#!/bin/bash

STATEFILE="$HOME/.imon_env"
[ -f "$STATEFILE" ] && source "$STATEFILE"
IM_NET_DEV=$( ip route  | grep default -m 1 | awk '{print $5}' )

if [ -z ${IM_OLD_TX+x} ]; then export IM_OLD_TX=0; fi
if [ -z ${IM_OLD_RX+x} ]; then export IM_OLD_RX=0; fi

IM_NEW_RX=$( cat /sys/class/net/$IM_NET_DEV/statistics/rx_bytes )
IM_NEW_TX=$( cat /sys/class/net/$IM_NET_DEV/statistics/tx_bytes )

echo "RX: $(($IM_NEW_RX-$IM_OLD_RX)) | TX: $(($IM_NEW_TX-$IM_OLD_TX))"
IM_OLD_RX=$IM_NEW_RX
IM_OLD_TX=$IM_NEW_TX

echo "export IM_OLD_RX=$IM_OLD_RX" > "$STATEFILE"
echo "export IM_OLD_TX=$IM_OLD_TX" >> "$STATEFILE"

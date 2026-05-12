#!/bin/sh

TRACE_OPTIONS="-i net1 tcp port 502" # trace modbus
TRACE_TIME=3600                      # trace for an hour

while [ 1 ]; do
    TRACE_FILE="/data/trace_$(date +"%F_%T").pcap"
    /bin/container_pcap ${TRACE_FILE} ${TRACE_TIME} ${TRACE_OPTIONS}
done

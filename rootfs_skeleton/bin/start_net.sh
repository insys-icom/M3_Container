#!/bin/sh

## If the gateway has not been configured by the router, the gateway address can be set here
#GATEWAY="192.168.1.1"

## If the DNS server address is different than the gateway address, the DNS server address can be set here
#DNS="192.168.1.1"


#####################################
# No need to edit stuff below this  #
#####################################

# detect, if the router configuration already configured a gateway
GATEWAY_GIVEN=$(/bin/ip route show | grep default | cut -d' ' -f 3)

# set the gateway that has been configured manually
if [ "${GATEWAY}" != "" ] ; then
    # delete the default route, in case it has been given by the routers configuration
    ip route del default
    /bin/ip route add default via "${GATEWAY}"
fi

# set the DNS that has been configured manually
if [ "${DNS}" != "" ] ; then
    echo "nameserver ${DNS}" > /etc/resolv.conf
else
    # set the DNS to the same address as the gateway, that has been given by the router configuration
    if [ "${GATEWAY_GIVEN}" != "" ] ; then
        echo "nameserver ${GATEWAY_GIVEN}" > /etc/resolv.conf
    fi
fi

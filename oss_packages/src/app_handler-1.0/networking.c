#include <stdio.h>
#include "defines.h"

int setGateway(char *gw){
	FILE *net;

	net = fopen("/bin/start_net.sh", "w+");

	if(NULL == net){
	    perror("Error settings Gateway");
	    return FAIL;
	}

	fprintf(net, "#!/bin/sh\n\n");
	fprintf(net, "# set a default gateway:\n");
	fprintf(net, "/bin/ip route add default via %s\n", gw);

	fclose(net);

	return SUCCESS;
}

int setDNS(char *dns){
	FILE *resolv;

	resolv = fopen("/etc/resolv.conf", "w+");

	if(NULL == resolv) {
	    perror("Error setting DNS");
	    return FAIL;
	}

	fprintf(resolv, "nameserver %s\n", dns);

	fclose(resolv);

	return SUCCESS;
}

#include "defines.h"

void *web_s_network(void) {
    char dns[NETWORK_BUFFER], gw[NETWORK_BUFFER];

    visited("network");

    /* Read data from files */
    getDNS(dns, NETWORK_BUFFER);
    getGateway(gw, NETWORK_BUFFER);

    fprintf(output, "<form action=\"web_c_network.cgi\" method=post>\n");

    /* Network */
    start_box();
    fprintf(output, "<h1>%s</h1>", get_text("IP_NETWORK"));
    end_box();

    start_box();
    /* Gateway */
    fprintf(output, "<table><tr><td>%s</td><td>", get_text("GATEWAY"));
    print_input("text", "Gateway", gw, "float: right; margin-right: 500px;", "");
    fprintf(output, "</td><tr>");

    /* DNS */
    fprintf(output, "<tr><td>%s</td><td>", get_text("DNS"));
    print_input("text", "DNS", dns, "float: right; margin-right: 500px;", "");
    fprintf(output, "</td><tr></table>");
    end_box();

    /* Submit */
    start_box();
    print_input("submit", "btnSubNetwork", "OK", "margin-right:10px;", get_text("SAVE_TEXT"));
    end_box();

    fprintf(output, "</form>\n");

    return NULL;
}

void *web_c_network(void) {
    char *gw, *dns;
    FILE *tmp = fopen("/tmp/new_network", "w+");

    if(NULL == tmp) {
        /* Get back */
        web_s_network();
        return NULL;
    }

    /* Get data */
    gw = getenv("WWW_Gateway");
    dns = getenv("WWW_DNS");

    /* Check data */
    if(check_ip(gw) == SUCCESS && check_ip(dns) == SUCCESS) {
        fprintf(tmp, "%s\n", gw);
        fprintf(tmp, dns);
    }

    fclose(tmp);

    sleep(1);

    /* Get back */
    web_s_network();

    return NULL;
}

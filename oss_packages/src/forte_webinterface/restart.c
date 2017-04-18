#include "defines.h"

#include <dirent.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

#include "file_operations.h"

void *web_s_restart(void) {

    visited("restart");

    /* Print out page */

    /* Network */
    start_box();
    fprintf(output, "<h1>%s</h1>", get_text("RESTART"));
    end_box();

    fprintf(output, "<form action=\"web_c_restart_app.cgi\" method=post>\n");
    start_box();
    /* Submit */
    print_input("submit", "btnRestartApp", get_text("RESTART_APP"), "margin-right:10px;", "");
    end_box();
    fprintf(output, "</form>\n");

    fprintf(output, "<form action=\"web_c_restart_device.cgi\" method=post>\n");
    start_box();
    /* Submit */
    print_input("submit", "btnRestartDev", get_text("RESTART_CONTAINER"), "margin-right:10px;", "");
    end_box();
    fprintf(output, "</form>\n");

    return NULL;
}

void *web_c_restart_app(void) {

    if(system("touch /tmp/restart_app") == -1) {
        log_entry(LOG_FILE, "Error creating restart file");
    }

    web_s_restart();

    return NULL;
}

void *web_c_restart_device(void) {

    output = fopen(HTTP_OUTPUT_FILE, "w+");
    if(output == NULL)
        return NULL;

    fprintf(output, "\n<html><head><title>%s</title>\n", "Insys Container"/*welcome*/);
    fprintf(output, "<meta http-equiv=\"content-type\" content=\"text/html; charset=UTF-8\">");
    fprintf(output, "<meta http-equiv=\"expires\" content=\"0\">\n");
    fprintf(output, "<meta http-equiv=\"cache-control\" content=\"no-cache\">\n");
    fprintf(output, "<meta http-equiv=\"pragma\" content=\"no-cache\">\n");
    fprintf(output, "<link rel=\"icon\" type=\"image/png\" href=\"icons/favicon.png\">");
    /* Print style */
    fprintf(output, "<style type=\"text/css\">\nbody {\nbackground-color:#ececec;font-family:Arial,Helvetica,sans-serif;\nfont-size: 12pt;\n}\n\n");
    fprintf(output, "#sheet {\nposition: fixed;\ntop: 20%%;\nwidth: 100%%;\ntext-align: center;\npadding: 0px;\nmargin: 0px;\nborder: none;\n}</style>");
    /* Print meta for refresh */
    fprintf(output, "<meta http-equiv=\"refresh\" content=\"15;URL=web_s_overview.cgi\"\n");

    fprintf(output, "</head><body><div id=\"sheet\"><p>\n");

    fprintf(output, "%s\n<br><br>\n", get_text("RESTARTING_DEVICE"));
    fprintf(output, "<img src=\"icons/wait.gif\">\n");

    fprintf(output, "</p></div></body></html>\n");

    fclose(output);

    print_to_browser();

    if(system("touch /tmp/reboot") == .1) {
        log_entry(LOG_FILE, "Error creating reboot file");
    }

    return NULL;
}

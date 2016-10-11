#include "defines.h"
#include "settings_defines.h"

void web_main(char *cmdname)
{
    char visited[30];
    int i, entries = 0, left, right, x, cmp, found = 0, *ret;
    FILE *tmp;

    /* IMPORTANT: Keep alphabetical order! */
    /* web_s_XXXX are used to create the configuration-formular for the feature XXX
      web_c_XXXX are the web-scripts which execute the given data and configure the device */
    const func_tab web_functions[] = {        
        { "c_authentication.cgi",   web_c_authentication,   MENU_AUTH,      MODE_NONE  },
        { "c_configuration.cgi",    web_c_configuration,    MENU_CONFIG,    MODE_NONE  },
        { "c_network.cgi",          web_c_network,          MENU_NET,       MODE_NONE  },
        { "c_new_config.cgi",       web_c_new_config,       MENU_NEW_CONFIG,MODE_NONE  },
        { "c_restart_app.cgi",      web_c_restart_app,      MENU_RESTART,   MODE_NONE  },
        { "c_restart_device.cgi",   web_c_restart_device,   MENU_RESTART,   MODE_NONE  },

        { "s_authentication.cgi",   web_s_authentication,   MENU_AUTH,      MODE_NONE  },
        { "s_configuration.cgi",    web_s_configuration,    MENU_CONFIG,    MODE_NONE  },
        { "s_info.cgi",             web_s_info,             MENU_INFO,      MODE_NONE  },
        { "s_log.cgi",              web_s_log,              MENU_LOG,       MODE_NONE  },
        { "s_network.cgi",          web_s_network,          MENU_NET,       MODE_NONE  },
        { "s_overview.cgi",         web_s_overview,         MENU_OVERVIEW,  MODE_NONE  },
        { "s_restart.cgi",          web_s_restart,          MENU_RESTART,   MODE_NONE  },

        { 0,                        0,                      0,              0          }
    };

    menu = MENU_VISITED;

    /* wanted the user switch the language of the webinterface? */
    if(LANGUAGE_SWITCH_ON) {
        if(strstr(cmdname, "web_c_lang_")) {
            if(strstr(cmdname, "lang_en")) {
                tmp = fopen(LANGUAGE, "w+");
                if(tmp != NULL) {
                    fputs("e\n", tmp);
                    fclose(tmp);
                }

                language = 'e';
            }

            if(strstr(cmdname, "lang_de")) {
                tmp = fopen(LANGUAGE, "w+");
                if(tmp != NULL) {
                    fputs("d\n", tmp);
                    fclose(tmp);
                }
                
                language = 'd';
            }

            tmp = fopen(VISITED, "r");
            if(tmp == NULL)
                sprintf(cmdname, "web_s_overview.cgi");
            else {
                fgets(visited, 29, tmp);
                strncpy(cmdname, "web_s_", strlen("web_s_"));
                cmdname[strlen("web_s_")] = '\0';
                strncat(cmdname, visited, strlen(visited) - 1);
                strncat(cmdname, ".cgi", 4);
                fclose(tmp);
            }
        }
    } else {
        language = 'e';
    }

    /* open a new file and print all HTML text into it, even if there nobody wants to see html */
    output = fopen(HTML_OUTPUT_FILE, "w+");
    if(output == NULL)
        return;

    get_welcome();

    /* call the function, that the user wants to see */
    if(strcmp(cmdname, "index.cgi") == 0) {
        menu = MENU_OVERVIEW;
        /* print start page */
        web_s_overview();
    }
    else { /* the user wants to see or configure a special feature: search struct, which function we should call */
        cmdname += 4; /* the first 4 signs are always "web_", so we can skip them */

        for(entries = 0; web_functions[entries].func_name != NULL; entries++);  /* count amount of functions */

        left = found = 0;
        right = entries;

        for(i = 1; right >= left; i++) {
            x = (left + right) / 2;         /* new search position */
            cmp = strcmp(cmdname, web_functions[x].func_name); /* compare strings */
            if(cmp == 0) {
                found = 1;
                break;;                     /* found -> return index*/
            }
            else if(cmp < 0)                /* smaller? */
                right = x - 1;              /* than we adjust right */
            else
                left = x + 1;               /* otherwise adjust left */
        }

        if(found) {
            menu = web_functions[x].menu;
            mode = web_functions[x].mode;

            ret = (int *)web_functions[x].p_func();
            if(ret != NULL)
                return;
        }
        else
            return;
    }

    /* prepare the file to be print to the browser if there was a cgi called or not:
    - finish printing HTML into HTML file
    - print HTTP head into HTTP file
    - attach HTML file to HTTP file */
    print_html_end();
    fclose(output);

    output = fopen(HTTP_OUTPUT_FILE, "w+");
    if(output == NULL)
        return;
    print_html_head(); /* print head into final file */
    print_navigation(menu); /* print navigation tree into final file */
    fclose(output);

    print_to_browser(); /* attach pre prepared HTML to final file and send it */

    return;
}


/* Main */
int main(int argc, char **argv)
{
    char *p, *cmdname = *argv;

    /* remove absolute path, we want only the filename itself */
    if ((p = strrchr(cmdname, '/')) != NULL)
        cmdname = p + 1;

    get_lang();

    /* If this has been called with exactly one argument, it has not been
       called from the webinterface but from the system inside. The neccessary
       environment variables have already been created.
       So: Do not run ungci(). The argument itself does not matter. */

    uncgi();
    refresh_string[0] = '\0';

    /* It has something to do with the webinterface, so start the web_main */
    web_main(cmdname);

    return 0;
}

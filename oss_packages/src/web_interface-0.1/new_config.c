#include "defines.h"
#include "settings.h"
#include "settings_defines.h"

void *web_c_new_config(void) {

    /* Call app_handler */
    if(system("touch /tmp/activate_config") == -1) {
        log_entry(LOG_FILE, "Error creating activation file");
    }

    sleep(1);

    web_s_overview();

    return NULL;
}

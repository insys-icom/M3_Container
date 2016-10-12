#include "defines.h"
#include "settings.h"
#include "settings_defines.h"

void *web_c_new_config(void) {

<<<<<<< HEAD
    /* Call app_handler */
    if(system("touch /tmp/activate_config") == -1) {
        log_entry(LOG_FILE, "Error creating activate-config file");
    }
=======
	/* Call app_handler */
	if(system("touch /tmp/activate_config") == -1) {
		log_entry(LOG_FILE, "Error creating activate-config file");
	}
>>>>>>> f150bc17286bde169b4dd8c8b7fb73781a2e1e16

    sleep(1);

    web_s_overview();

<<<<<<< HEAD
    return NULL;
=======
	return NULL;
>>>>>>> f150bc17286bde169b4dd8c8b7fb73781a2e1e16
}

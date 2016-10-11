#include "defines.h"
#include "settings.h"
#include "settings_defines.h"

void *web_c_new_config(void) {

	/* Call app_handler */
	system("touch /tmp/activate_config");

	sleep(1);

	web_s_overview();

	return NULL;
}
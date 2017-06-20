#include "defines.h"
#include "settings.h"
#include "settings_defines.h"

void *web_s_configuration(void) {

	struct setting settings[SETTINGS_COUNT] = {};
	
	visited("configuration");

	/* Initialize settings from settings.h */
	init_settings(settings, SETTINGS_COUNT);

	/* Start printing page */
	fprintf(output, "<form action=\"web_c_configuration.cgi\" method=post>\n");

	start_box();
	fprintf(output, "<h1>%s</h1>\n", get_text("CONFIGURATION"));
	end_box();

	/* MQTT */
	start_box();
	fprintf(output, "For this container no configuration is necessary.");

	end_box(); /* box */

	fprintf(output, "</form>\n");

	return NULL;
}

void *web_c_configuration(void) {

	sleep(1);

	web_s_configuration();

	return NULL;
}

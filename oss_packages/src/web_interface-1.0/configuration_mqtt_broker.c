#include "defines.h"
#include "settings.h"
#include "settings_defines.h"

void *web_s_configuration(void) {

	struct setting settings[SETTINGS_COUNT] = {
		{	"BIND_ADDRESS", 		"bind_address", 	""	},
		{	"PORT",					"port", 	""	},
	};

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
	fprintf(output, "<h3>MQTT - Broker</h3>\n");

	fprintf(output, "<table><tr><td>%s</td><td>", settings[SETTING_BIND_ADDRESS].name);
	print_input("text", settings[SETTING_BIND_ADDRESS].input_name, settings[SETTING_BIND_ADDRESS].value, "float: right; margin-right: 500px;", "");
	fprintf(output, "</td></tr>");

	fprintf(output, "<tr><td>%s</td><td>", settings[SETTING_PORT].name);
	print_input("text", settings[SETTING_PORT].input_name, settings[SETTING_PORT].value, "float: right; margin-right: 500px;", "");
	fprintf(output, "</td><tr></table>");
	end_box(); /* box */

	/* Button */
	start_box();
	print_input("submit", "btnSubConfiguration", "OK", "margin-right:10px;", get_text("SAVE_TEXT"));
	end_box();

	fprintf(output, "</form>\n");

	return NULL;
}

void *web_c_configuration(void) {
	FILE *config;

	char line[200];

	/* Open config file for rewrite */
	config = fopen("/tmp/new_config", "w+");
	fputs("##### Container Configuration #####\n", config);

	/* MQTT */
	fputs("\n##### MQTT - Broker - Configuration #####\n", config);
	get_line(line, "bind_address");
	fputs(line, config);
	get_line(line, "port");
	fputs(line, config);

	/* Logging */
	fputs("\n# Logging\n", config);
	fputs("log_dest syslog\n", config);
	fputs("log_facility 5\n", config);
	fputs("log_type all\n\n", config);
	fputs("connection_messages true\n", config);
	fputs("log_timestamp true", config);

	/* Close data */
	fclose(config);

	sleep(1);

	web_s_configuration();

	return NULL;
}

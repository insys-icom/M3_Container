#include "defines.h"
#include "settings.h"
#include "settings_defines.h"
#include "file_operations.h"

void init_settings(struct setting settings[], int count) {
  int i;
  char line[200];
  char *file = "/usr/application/configuration.config";

  FILE *config;

  /* Reaplace names */
  for(i = 0; i < count; i++) {
	  memcpy(settings[i].name, get_text(settings[i].name), 100);
  }

  /* Open and check config file */
  if(check_file("/tmp/new_config") != FILE_NOT_EXIST) {
	  file = "/tmp/new_config";
  }
  config = fopen(file, "r");

  if(config == NULL) {
	  perror("Error opening configfile");
	  return;
  }

  /* Get values */
  while(fgets(line, sizeof(line), config)) {
    /* Skip comment and empty lines */
    if(line[0] == '#' || line[0] == '\0' || line[0] == ' ')
	    continue;

    /* Search for "=" */
    if(NULL == strstr(line, CONFIG_DELIMITER))
	    continue;

    /* Split line after "=" */
    strtok(line, CONFIG_DELIMITER);

    for(i = 0; i < count; i++) {
      if(strcmp(line, settings[i].input_name) == 0) {
	      /* Set value of settings */
	      strncpy(settings[i].value, strtok(NULL, CONFIG_DELIMITER), 100);

	      /* Leave loop to avoid writing value a second time */
	      break;
      }
    }
  }

  fclose(config);

  return;
}

/* function to get values of enviroment variables and build lines of config files */
void get_line(char *line, char *val) {
  char *str;
  /* uncgi sets values to enviroment variables starting with "WWW_" so initialize field with this */
  char var[100] = "WWW_";

  /* append name of variable to var */
  strcat(var, val);

  /* get value of enviroment variable */
  str = getenv(var);

  /* check value and build a config line */
  if(NULL == str || check_string_empty(str)) {
	  sprintf(line, "\n");
  } else {
	  sprintf(line, "%s%s%s\n", val, CONFIG_DELIMITER, str);
  }

  return;
}

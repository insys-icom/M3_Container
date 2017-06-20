#ifndef SETTINGS_H
#define SETTINGS_H

struct setting {
	char name[100];
	char input_name[100];
	char value[100];
};

void init_settings(struct setting settings[], int count);
void get_line(char *line, char *val);

#endif
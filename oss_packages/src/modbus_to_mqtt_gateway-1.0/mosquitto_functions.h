#ifndef MOSQUITTO_FUNCTIONS_H_INCLUDED
#define MOSQUITTO_FUNCTIONS_H_INCLUDED

#include <mosquitto.h>

struct mosquitto * mosquitto_initialize(char *path_to_config);
int mosquitto_quit(struct mosquitto *mosq);
int mosquitto_pub(struct mosquitto *mosq, const char *topic, int len, const void *payload);

#endif // MOSQUITTO_FUNCTIONS_H_INCLUDED

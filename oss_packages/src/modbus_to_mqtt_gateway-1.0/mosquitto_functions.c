#include <mosquitto.h>
#include <stdlib.h>
#include <stdio.h>
#include "error_defines.h"
#include "read_config.h"
#include "main.h"
#include "logging.h"

/* Initalizing and connecting mosquitto */
struct mosquitto *mosquitto_initialize(char *path_to_config)
{
    struct mosquitto *mosq = NULL;

	char host[BUFFER_SIZE];
	int port = 1884;
	int keepalive = 120;
	bool clean_session = true;

    /* Set default values */
    sprintf(host, "192.168.1.0");

    /* Read Configuration */
    log_entry(APP_NAME, "Reading Mosquitto - Configuration");
    printf("\nReading Mosquitto - Configuration..\n");
    if(getStringFromFile_n(path_to_config, "mosquitto_address", host, BUFFER_SIZE) == -1) {
        log_entry(APP_NAME, "Error reading broker address");
        printf("Error reading broker address..\n");
        return NULL;
    }

    port = getIntFromFile(path_to_config, "mosquitto_port");
    if(port == -1) {
        log_entry(APP_NAME, "Error reading broker port"),
        printf("Error reading broker port-..\n");
        return NULL;
    }

    printf("Broker-Address: %s\nport: %d\n", host, port);

    /* Initialize library */
	mosquitto_lib_init();

    /* Set up client */
    log_entry(APP_NAME, "Setting up and connecting Mosquitto");
    printf("\nSetting up and connecting Mosquitto..\n");
	mosq = mosquitto_new(NULL, clean_session, NULL);

	if(!mosq) {
        log_entry(APP_NAME, "Error setting up mosquitto");
		fprintf(stderr, "Error setting up mosquitto.\n");
		return NULL;
	}

	if(mosquitto_connect(mosq, host, port, keepalive)) {
        log_entry(APP_NAME, "Error connecting mosquitto");
		fprintf(stderr, "Error connecting mosquitto.\n");
		return NULL;
	}

    /* Message to user */
    log_entry(APP_NAME, "Setup and Connection successful");
    printf("Setup and Connection successful.\n\n");

    return mosq;
}

/* Publish message to Broker */
int mosquitto_pub(struct mosquitto *mosq, const char *topic, int len, const void *payload)
{
    if(mosquitto_publish(mosq, NULL, topic, len, payload, 1, true) != MOSQ_ERR_SUCCESS) {
        log_entry(APP_NAME, "Unable to publish value");
        fprintf(stderr, "Unable to publish value.\n");
        return ERROR;
    }

    return SUCCESS;
}

/* Quit and destroy mosquitto */
int mosquitto_quit(struct mosquitto *mosq)
{
    mosquitto_disconnect(mosq);
	mosquitto_destroy(mosq);
	mosquitto_lib_cleanup();

	return SUCCESS;
}

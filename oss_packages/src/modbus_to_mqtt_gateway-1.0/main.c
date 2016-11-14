#include <stdio.h>
#include <stdlib.h>
#include <modbus/modbus.h>
#include <time.h>
#include "logging.h"
#include "error_defines.h"
#include "modbus_functions.h"
#include "mosquitto_functions.h"
#include "read_config.h"
#include <unistd.h>
#include <string.h>
#include <inttypes.h>
#include "logging.h"
#include "main.h"

/* we don't care if tv_sec overflows, because if this should happen after 136 years of operation, i will not have to support it */
int diff(struct timespec *start, struct timespec *end)
{
    struct timespec diff;

    if ((end->tv_nsec - start->tv_nsec) < 0) {
            diff.tv_sec = end->tv_sec - start->tv_sec - 1;
            diff.tv_nsec = 1000000000 + end->tv_nsec - start->tv_nsec;
    } else {
            diff.tv_sec = end->tv_sec - start->tv_sec;
            diff.tv_nsec = end->tv_nsec - start->tv_nsec;
    }

    return diff.tv_sec * 1000 + diff.tv_nsec / 1000000;
}

/* Check values read from the configfile */
int check_values(int no_register, int pollingInterval)
{
    /* Check polling interval */
    if(pollingInterval <= 0) {
        log_entry(APP_NAME, "Error: Please enter a correct value for polling interval.\n(This must be a positive Integer)");
        printf("Error: Please enter a correct value for polling interval.\n(This must be a positive Integer)\n");
        return ERROR;
    }

    /* Check number of registers */
    if(no_register < 0) {
        log_entry(APP_NAME, "Error: Please enter a correct value for the number of modbusregisters to read.\n(This must be a positive Integer)");
        printf("Error: Please enter a correct value for the number of modbusregisters to read.\n(This must be a positive Integer)\n");
        return ERROR;
    }

    return SUCCESS;
}

/* wait for app_handler to restart the application in case of a new configuration */
void wait_for_new_config() {
    while(1) {
        sleep(100);
    }
}

int main(void)
{

/* ######################### Variables #########################  */

    /* Variables for modbus */
    modbus_t *ctx;
    int pollingInterval;
    uint16_t valueArray[2];
    float floatValue;
    int no_register;
    uint8_t desiredBit;
    GenDataType_t dataType;
    MoBuRegType_t registerType;

    /* Variables for mosquitto */
    struct mosquitto *mosq;
    char topic[BUFFER_SIZE];
    char text[50];

    /* Variables for time */
    struct timespec last_read_time;
    struct timespec now;


/* ######################### Initialize variables #########################  */

    sprintf(topic, "/test");

    /* Read values from configfile */
    if(getStringFromFile_n(CONFIG_FILE_PATH, "mosquitto_topic", topic, BUFFER_SIZE) == -1) {
        log_entry(APP_NAME, "Error reading topic");
        printf("Error reading topic..\n");
        
        /* wait for new config */
        wait_for_new_config();
        
        return EXIT_FAILURE;
    }

    pollingInterval = getIntFromFile(CONFIG_FILE_PATH, "modbus_polling_Interval");
    no_register = getIntFromFile(CONFIG_FILE_PATH, "modbus_register");
    dataType = getIntFromFile(CONFIG_FILE_PATH, "modbus_data_type");
    registerType = getIntFromFile(CONFIG_FILE_PATH, "modbus_register_type");
    desiredBit = getIntFromFile(CONFIG_FILE_PATH, "modbus_desired_bit");

    /* Check values of variables */
    if(check_values(no_register, pollingInterval) == ERROR) {
        log_entry(APP_NAME, "Error: Invalid values");
        
        /* wait for new config */
        wait_for_new_config();
        
        return EXIT_FAILURE;
    }


/* ######################### Initialize communication #########################  */

    /* Initialize Mosquitto */
    printf(SPLIT_LINE);
    mosq = mosquitto_initialize(CONFIG_FILE_PATH);
    if(mosq == NULL) {
        log_entry(APP_NAME, "Error: Could not initialize mqtt connection");

        /* wait for new config */
        wait_for_new_config();

        return EXIT_FAILURE;
    }

    /* Initialize Modbus */
    printf(SPLIT_LINE);
    ctx = modbus_init(CONFIG_FILE_PATH);
    if(ctx == NULL) {
        log_entry(APP_NAME, "Error: Could not initialize modbus connection");

        /* wait for new config */
        wait_for_new_config();

        return EXIT_FAILURE;
    }

    /* Initialize time */
    clock_gettime(CLOCK_MONOTONIC, &last_read_time);


/* ######################### Start application #########################  */

    printf(SPLIT_LINE);
    log_entry(APP_NAME, "Start reading values..");
    printf("\nStart reading values..\n\n");

    /* Endless Loop */
    while(1)
    {
        clock_gettime(CLOCK_MONOTONIC, &now);

        /* Check if polling time is over (multiply with 1000 to calculate seconds) */
        if(diff(&last_read_time, &now) >= pollingInterval * 1000) {

            /* Read values from modbus */
            if(read_modbus(ctx, 0, no_register, dataType, registerType, desiredBit, valueArray) == ERROR) {
                /* Set last read time */
                clock_gettime(CLOCK_MONOTONIC, &last_read_time);
                continue;
            }

            switch(dataType)
            {
                case bitCoil:
                case sint16:
                case sint32:
                case uint16:
                case uint32:
                    floatValue = modbus_get_float(valueArray);
                    sprintf(text, "%.0f", floatValue);
                    break;
                case float32:
                    floatValue = modbus_get_float(valueArray);
                    sprintf(text, "%.2f", floatValue);
                    break;
            }

            /* Message for user */
            printf("Value: %s\n", text);

            /* Publish value */
            if(mosquitto_pub(mosq, topic, strlen(text), text) == SUCCESS) {
                log_entry(APP_NAME, "Published value successfully");
                printf("Published value successfully.\n\n");
            } else {
                log_entry(APP_NAME, "Error: Value could not be published.");
                printf("Error: Value could not be published.\n");
            }

            /* Set last read time */
            clock_gettime(CLOCK_MONOTONIC, &last_read_time);
        }

        /* taking care of processor and slow down the loop */
        usleep(500);
    }

    /* We should never get here */
    mosquitto_quit(mosq);
    modbus_quit(ctx);

    log_entry(APP_NAME, "Quit application");

    return EXIT_SUCCESS;
}

#include <modbus/modbus.h>
#include <stdio.h>
#include <stdlib.h>
#include "read_config.h"
#include "error_defines.h"
#include <errno.h>
#include "modbus_functions.h"
#include <string.h>
#include "logging.h"
#include "main.h"

/* Initializing and connecting modbus */
modbus_t *modbus_init(char *path_to_config)
{
    char ip[BUFFER_SIZE];
    int port;
    modbus_t *ctx = (modbus_t *) malloc(1);

    /* Set default values */
    sprintf(ip, "127.0.0.1");
    port = 502;

    /* Read Configuration */
    log_entry(APP_NAME, "Reading Modbus - Configuration");
    printf("\nReading Modbus - Configuration..\n");

    port = getIntFromFile(path_to_config, "modbus_port");
    if(getStringFromFile_n(path_to_config, "modbus_address", ip, BUFFER_SIZE) == -1) {
        log_entry(APP_NAME, "Error reading modbus address");
        printf("Error reading modbus_address..\n");
    }

    printf("IP-Address: %s\nport: %d\n", ip, port);

    /* Set up modbus */
    log_entry(APP_NAME, "Setting up and connecting Modbus");
    printf("\nSetting up and connecting Modbus..\n");
    ctx = modbus_new_tcp(ip, port);

    /* Check Setup */
    if(ctx == NULL) {
        log_entry(APP_NAME, "Error setting up modbus");
        printf("Error setting up modbus.\n");
        return NULL;
    }

    /* Connect and set slave */
    if(modbus_connect(ctx) != 0 || modbus_set_slave(ctx, MODBUS_SLAVE_ADDRESS) != 0) {
        log_entry(APP_NAME, "Error connecting modbus");
        printf("Error connecting modbus.\n");
        return NULL;
    }

    /* Message to user */
    log_entry(APP_NAME, "Setup and Connection successful");
    printf("Setup and Connection successful.\n\n");

    return ctx;
}

/* Obsolete */
/* Read values from modbus-register */
int modbus_read_value(modbus_t *ctx, int address, float *value)
{
    uint16_t val[2];

    /* Check if modbus is set up */
    if(ctx == NULL) {
        log_entry(APP_NAME, "Modbus: Error, No Context");
        printf("Modbus: Error, No Context..\n");
        return -1;
    }

    /* Read data from modbus */
    if(modbus_read_registers(ctx, address, 2, val) <= 0) {
        fprintf(stderr, "Modbus: Reading error: %s\n", modbus_strerror(errno));
        return -1;
    }

    /* Convert value to float */
    *value = modbus_get_float(val);

    if(value == NULL) {
        return ERROR ;
    } else {
        return SUCCESS;
    }
}

/* Quit and destroy modbus-connection */
int modbus_quit(modbus_t *ctx)
{
    modbus_close(ctx);
    modbus_free(ctx);

    return SUCCESS;
}

/* Read values from modbus */
uint8_t read_modbus(modbus_t *ctx, uint8_t readOrWrite, uint16_t modbusRegister, GenDataType_t typeOfValue, MoBuRegType_t typeOfReg, uint8_t desiredBit, uint16_t* valueArray)
{
    uint8_t noOfRegisters = 0;
    uint16_t modbusValueArray[2];
    uint16_t modbusTmpValue; //used for bit values read from registers

    memset(modbusValueArray, 0x00, (sizeof(uint16_t) * 2));

    if (readOrWrite > 0) {
        log_entry(APP_NAME, "invalid parameter in read_modbus: Only reading values supported");
        printf("invalid parameter in read_modbus: Only reading values supported");
        return -1;
    }

    switch (typeOfValue)
    {
    case bitCoil:
    case sint16: // read one address
    case uint16: //read one address
        noOfRegisters = 1;
        break;

    case sint32: //read 2 registers
    case uint32:
    case float32:
        noOfRegisters = 2;
        break;

    default:
        log_entry(APP_NAME, "MODBUSD; unknown dataType");
        printf("MODBUSD; unknown dataType: %d", typeOfValue);
    }

    switch (typeOfReg)
    {
    case coil:
        if (0 == readOrWrite) { //read
            if (1 != modbus_read_bits(ctx, modbusRegister, 1, (uint8_t *) modbusValueArray)) {
                log_entry(APP_NAME, "MODBUSD: could not read coils");
                printf("MODBUSD: could not read coils: %d, %s", modbusRegister, strerror(errno));
                return -1;
            }
        } else {
            /* first read the whole unit16 value */
            if (1 == modbus_read_bits(ctx, modbusRegister, 1, (uint8_t *) modbusValueArray)) {

                if (valueArray[0] == 0) {
                    modbusTmpValue = 0;
                } else if (valueArray[0] == 1) {
                    //setting bit to 1
                    modbusTmpValue = 1;
                } else {
                    //toggle the bit
                    if(0 == modbusValueArray[0]){
                        modbusTmpValue = 1;
                    }
                    else {
                        modbusTmpValue = 0;
                    }
                }

                if (1 !=  modbus_write_bit(ctx, modbusRegister, modbusTmpValue)) {
                    return -1;
                }
            }
        }
        break;

    case discrete_input:
        if (0 == readOrWrite) { //read
            if (1 != modbus_read_input_bits(ctx, modbusRegister, noOfRegisters, (uint8_t *) &(modbusValueArray[0]))) {
                log_entry(APP_NAME, "MODBUSD: could not read input");
                printf("MODBUSD: could not read input: %d, %s", modbusRegister, strerror(errno));
                return -1;
            }
        } else {
            log_entry(APP_NAME, "MODBUSD: illegal operation -> unable to write on discrete input");
            printf("MODBUSD: illegal operation -> unable to write on discrete input");
        }
        break;

    case holding_register:
        if (0 == readOrWrite) { //read
            if (1 != modbus_read_registers(ctx, modbusRegister, noOfRegisters, &(modbusValueArray[0]))) {
                return -1;
            }
        } else {
            if (1 != modbus_write_registers(ctx, modbusRegister, noOfRegisters, &(valueArray[0]))) {
                return -1;
            }
        }
        break;

    case input_register:
        if (0 == readOrWrite) { //read
            if (1 != modbus_read_input_registers(ctx, modbusRegister, noOfRegisters, &(modbusValueArray[0]))) {
                log_entry(APP_NAME, "MODBUSD: could not read input registers");
                printf("MODBUSD: could not read input registers: %d, %s", modbusRegister, strerror(errno));
                return -1;
            }
        } else {
            log_entry(APP_NAME, "unable to write on input register");
            printf("unable to write on input register");
        }
        break;

    case holding_bit:
        if (0 == readOrWrite) { //read
            if (1 == modbus_read_registers(ctx, modbusRegister, noOfRegisters, &modbusTmpValue)) {
                modbusValueArray[0] = modbusTmpValue & (1 << desiredBit);
            } else {
                return -1;
            }

        } else {
            /* first read the whole unit16 value */
            if (1 == modbus_read_registers(ctx, modbusRegister, noOfRegisters, &modbusTmpValue)) {

                if (valueArray[0] == 0) {
                    //clearing a bit at postion desired bit
                    modbusTmpValue &= ~(1 << desiredBit);
                } else if (valueArray[0] == 1) {
                    //setting bit to 1
                    modbusTmpValue |= 1 << desiredBit;
                } else {
                    //toggle the bit
                    modbusTmpValue ^= 1 << desiredBit;
                }

                if (1 != modbus_write_registers(ctx, modbusRegister, noOfRegisters, &modbusTmpValue)) {
                    return -1;
                }

            } else {
                return -1;
            }
        }
        break;

    case input_bit:
        if (0 == readOrWrite) { //read
            if (1 == modbus_read_input_registers(ctx, modbusRegister, noOfRegisters, &modbusTmpValue)) {
                modbusValueArray[0] = modbusTmpValue & (1 << desiredBit);
            } else {
                return -1;
            }
        } else {
            log_entry(APP_NAME, "MODBUSD; unable to write single bit for input register");
            printf("MODBUSD; unable to write single bit for input register");
            return -1;
        }
        break;

    default:
        log_entry(APP_NAME, "MODBUSD; unknown register type");
        printf("MODBUSD; unknown register type %d", typeOfReg);
    }

    if (0 == readOrWrite) { //read
        valueArray[0] = modbusValueArray[0];
        valueArray[1] = modbusValueArray[1];
    }

    return 1;
}

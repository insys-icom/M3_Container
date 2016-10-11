#ifndef MODBUS_FUNCTIONS_H_INCLUDED
#define MODBUS_FUNCTIONS_H_INCLUDED

#include <modbus/modbus.h>

#define MODBUS_SLAVE_ADDRESS    20

modbus_t *modbus_init(char *path_to_config);
int modbus_quit(modbus_t *ctx);

/* meta flag used to describe an generic objectValue amongst others */
typedef enum {
    bitCoil =   0,
    sint16  =   1,
    uint16  =   2,
    sint32  =   3,
    uint32  =   4,
    float32 =   5,
} GenDataType_t;

typedef enum {
    coil                = 0, //Discrete Output > bit ON/OFF
    discrete_input      = 1, //bit -> ON/OFF
    holding_register    = 2,
    input_register      = 3,
    holding_bit         = 4,
    input_bit           = 5,
    none                = 6,
} MoBuRegType_t;



uint8_t read_modbus(modbus_t *ctx, uint8_t readOrWrite, uint16_t modbusRegister, GenDataType_t typeOfValue, MoBuRegType_t typeOfReg, uint8_t desiredBit, uint16_t* valueArray);

#endif // MODBUS_FUNCTIONS_H_INCLUDED

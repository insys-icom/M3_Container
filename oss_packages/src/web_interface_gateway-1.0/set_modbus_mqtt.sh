#!/bin/sh

rm settings_defines.h
rm configuration.c

ln -s configs/modbus_mqtt/configuration_modbus_mqtt.c configuration.c
ln -s configs/modbus_mqtt/settings_defines_modbus_mqtt.h settings_defines.h

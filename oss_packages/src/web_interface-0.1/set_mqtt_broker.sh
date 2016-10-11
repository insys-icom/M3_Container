#!/bin/sh

rm settings_defines.h
rm configuration.c

ln -s configs/mqtt_broker/configuration_mqtt_broker.c configuration.c
ln -s configs/mqtt_broker/settings_defines_mqtt_broker.h settings_defines.h

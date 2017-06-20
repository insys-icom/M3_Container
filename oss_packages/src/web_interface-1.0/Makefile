# adjust the following path if neccessary, everything else depends on it
TOPDIR = $(abspath $(PWD)/../..)

# PWD does not append a final /, so we can use notdir to get the folder name we are in
PROJECT_NAME = $(notdir $(PWD))

include $(TOPDIR)/scripts/common_settings.mk

CFLAGS = -Wall -I$(STAGING_DIR)/include $(OPTIMIZE_CFLAGS)
LDFLAGS = $(OPTIMIZE_LDFLAGS)

BUILD_DIR := $(TOPDIR)/working/$(PROJECT_NAME)
STAGING_DIR := $(TOPDIR)/rootfs_staging/

INCLUDES := $(wildcard *.h)

SRC := web.c administration.c authentication.c configuration.c file_operations.c helpers.c html.c network.c new_config.c overview.c restart.c settings.c uncgi.c 
OBJS := $(patsubst %.c, $(OBJ_DIR)%.o,$(SRC))

BUILD_DIRS := $(sort $(dir $(OBJS)))
BUILD_DIRS := $(addsuffix .keep,$(BUILD_DIRS))

TARGETS := $(BUILD_DIR)/$(PROJECT_NAME)

%: %.o

# rule for creating directories
.PHONY: .keep
%.keep:
	$(VERB)mkdir -p $(dir $@)
	$(VERB)touch $@

%.o : %.c $(INCLUDES) $(BUILD_DIRS)
	$(VERB)$(CC) $(CFLAGS) -c $< -o $@

.PHONY: all
all: web_interface_forte web_interface_modbus_mqtt_gateway web_interface_mosquitto_mqtt_broker

web_interface_forte: $(OBJS)
	$(CC) -o $@ $(OBJS) $(LDFLAGS)	
	
web_interface_modbus_mqtt_gateway: $(OBJS)
	$(CC) -o $@ $(OBJS) $(LDFLAGS)

web_interface_mosquitto_mqtt_broker: $(OBJS)
	$(CC) -o $@ $(OBJS) $(LDFLAGS)

.PHONY: clean
clean:
	$(VERB)rm -f $(OBJS) $(TARGETS) $(BUILD_DIRS)

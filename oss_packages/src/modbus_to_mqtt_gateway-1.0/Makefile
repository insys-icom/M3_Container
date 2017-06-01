# adjust the following path if neccessary, everything else depends on it
TOPDIR = $(abspath $(PWD)/../..)

# PWD does not append a final /, so we can use notdir to get the folder name we are in
PROJECT_NAME = $(notdir $(PWD))

include $(TOPDIR)/scripts/common_settings.mk

CFLAGS = -Wall -I$(STAGING_DIR)/include -I$(STAGING_DIR)/usr/local/include $(OPTIMIZE_CFLAGS)
LDFLAGS = $(OPTIMIZE_LDFLAGS) -L$(STAGING_DIR)/lib -L$(STAGING_DIR)/usr/local/lib -lssl -lcrypto -lmosquitto -lmodbus -lcares

BUILD_DIR := $(TOPDIR)/working/$(PROJECT_NAME)
STAGING_DIR := $(TOPDIR)/rootfs_staging/

INCLUDES := $(wildcard *.h)

OBJS := $(patsubst %.c,%.o,$(wildcard *.c))
OBJS := $(notdir $(OBJS))
OBJS := $(addprefix $(BUILD_DIR)/,$(OBJS))

BUILD_DIRS := $(sort $(dir $(OBJS)))
BUILD_DIRS := $(addsuffix .keep,$(BUILD_DIRS))

TARGETS := $(BUILD_DIR)/$(PROJECT_NAME)

# erase the implict rule
%.o: %.c

%: %.o

# rule for creating directories
%.keep:
	$(VERB)mkdir -p $(dir $@)
	$(VERB)touch $@

$(BUILD_DIR)/%.o: %.c $(INCLUDES) $(BUILD_DIRS)
	$(VERB)$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

.PHONY: all
all: $(TARGETS) $(BUILD_DIRS)

# rule for creating directories
%.keep:
	$(VERB)mkdir -p $(dir $@)
	$(VERB)touch $@

$(BUILD_DIR)/$(PROJECT_NAME): $(OBJS)
	$(VERB)$(CC) $(OBJS) $(LDFLAGS) -o $@

.PHONY: clean
# avoid rm -rf
clean:
	$(VERB)rm -f $(OBJS) $(TARGETS) $(BUILD_DIRS)
	-$(VERB)rmdir $(dir $(BUILD_DIRS))

.PHONY: install
install: $(TARGETS)
	$(VERB)cp $(TARGETS) $(STAGING_DIR)/bin

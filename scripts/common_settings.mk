CROSS_COMPILE = armv7a-hardfloat-linux-gnueabi-
CC := $(VERB)$(CROSS_COMPILE)gcc
LD := $(VERB)$(CROSS_COMPILE)ld
STRIP := $(VERB)$(CROSS_COMPILE)strip
CP = $(VERB)cp
RM = $(VERB)rm

CPU_THREADS=$(shell grep processor /proc/cpuinfo | wc -l)

OPTIMIZE_CFLAGS = -Os -funwind-tables -mthumb -march=armv7-a  -mtune=cortex-a8 -flto=$(CPU_THREADS) -fuse-linker-plugin -ffunction-sections -fdata-sections
OPTIMIZE_LDFLAGS = -Wl,--as-needed -funwind-tables -Os -mthumb -march=armv7-a -mtune=cortex-a8 -flto=$(CPU_THREADS) -fuse-linker-plugin -Wl,--gc-sections

export MAKEFLAGS=-j$(CPU_THREADS)

STAGING_DIR := $(abspath $(TOPDIR)/rootfs_staging/)

-include $(TOPDIR)/scripts/custom_settings.mk

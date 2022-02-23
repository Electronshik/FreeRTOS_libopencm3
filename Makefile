PROJECT = firmware
BUILD_DIR = build

INCLUDES_DIR = ./
INCLUDES_DIR += ./FreeRTOS-Kernel/include
INCLUDES_DIR += ./FreeRTOS-Kernel/portable/GCC/ARM_CM4F
INCLUDES_DIR += ./libopencm3/stm32

CFILES = main.c
CFILES += $(shell find ./FreeRTOS-Kernel/*.c)
CFILES += $(shell find ./FreeRTOS-Kernel/portable/GCC/ARM_CM4F/*.c)
#AFILES += api-asm.S

$(info $(CFILES))

# TODO - you will need to edit these two lines!
DEVICE=stm32f429zi
OOCD_FILE = board/stm32f4discovery.cfg

# You shouldn't have to edit anything below here.
VPATH += $(INCLUDES_DIR)
INCLUDES += $(patsubst %,-I%, . $(INCLUDES_DIR))
OPENCM3_DIR=./libopencm3

include $(OPENCM3_DIR)/mk/genlink-config.mk
include ./rules.mk
include $(OPENCM3_DIR)/mk/genlink-rules.mk

build-sub:
	git submodule update --init --recursive
	$(MAKE) $(MFLAGS) -C libopencm3 lib

rebuild-sub:
	git submodule deinit -f .
	git submodule update --init --recursive
	$(MAKE) $(MFLAGS) -C libopencm3 lib

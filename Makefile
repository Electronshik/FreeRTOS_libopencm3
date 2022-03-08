PROJECT = firmware
BUILD_DIR = build

INCLUDES_DIR = ./
INCLUDES_DIR += ./FreeRTOS-Kernel/include
INCLUDES_DIR += ./libopencm3/stm32

CFILES = main.c
CFILES += $(shell find ./FreeRTOS-Kernel/*.c)

#heap_1.c...heap_5.c file
CFILES += ./FreeRTOS-Kernel/portable/MemMang/heap_4.c

DEVICE = stm32f429zi
#DEVICE = stm32f103c8t6
OOCD_FILE = board/stm32f4discovery.cfg

OPENCM3_DIR = ./libopencm3

rtos_mcu_family		:=$(shell $(OPENCM3_DIR)/scripts/genlink.py $(OPENCM3_DIR)/ld/devices.data $(DEVICE) FAMILY)
rtos_mcu_subfamily	:=$(shell $(OPENCM3_DIR)/scripts/genlink.py $(OPENCM3_DIR)/ld/devices.data $(DEVICE) SUBFAMILY)
rtos_mcu_cpu		:=$(shell $(OPENCM3_DIR)/scripts/genlink.py $(OPENCM3_DIR)/ld/devices.data $(DEVICE) CPU)
rtos_mcu_fpu		:=$(shell $(OPENCM3_DIR)/scripts/genlink.py $(OPENCM3_DIR)/ld/devices.data $(DEVICE) FPU)
rtos_mcu_cppflags	:=$(shell $(OPENCM3_DIR)/scripts/genlink.py $(OPENCM3_DIR)/ld/devices.data $(DEVICE) CPPFLAGS)

$(info rtos_mcu_family: $(rtos_mcu_family))
$(info rtos_mcu_subfamily: $(rtos_mcu_subfamily))
$(info rtos_mcu_cpu: $(rtos_mcu_cpu))
$(info rtos_mcu_fpu: $(rtos_mcu_fpu))
$(info rtos_mcu_cppflags: $(rtos_mcu_cppflags))

ifeq ($(rtos_mcu_cpu), cortex-m3)
	ifeq ($(rtos_mcu_fpu), soft)
		CFILES += $(shell find ./FreeRTOS-Kernel/portable/GCC/ARM_CM3_MPU/*.c)
		INCLUDES_DIR += ./FreeRTOS-Kernel/portable/GCC/ARM_CM3_MPU
	else
		CFILES += $(shell find ./FreeRTOS-Kernel/portable/GCC/ARM_CM3/*.c)
		INCLUDES_DIR += ./FreeRTOS-Kernel/portable/GCC/ARM_CM3
	endif
endif

ifeq ($(rtos_mcu_cpu), cortex-m4)
	ifeq ($(rtos_mcu_fpu), soft)
		CFILES += $(shell find ./FreeRTOS-Kernel/portable/GCC/ARM_CM4_MPU/*.c)
		INCLUDES_DIR += ./FreeRTOS-Kernel/portable/GCC/ARM_CM4_MPU
	else
		CFILES += $(shell find ./FreeRTOS-Kernel/portable/GCC/ARM_CM4F/*.c)
		INCLUDES_DIR += ./FreeRTOS-Kernel/portable/GCC/ARM_CM4F
	endif
endif

ifeq ($(rtos_mcu_cpu), cortex-m7)
	CFILES += $(shell find ./FreeRTOS-Kernel/portable/GCC/ARM_CM7/r0p1/*.c)
	INCLUDES_DIR += ./FreeRTOS-Kernel/portable/GCC/ARM_CM7/r0p1
endif

$(info $(CFILES))

VPATH += $(INCLUDES_DIR)
INCLUDES += $(patsubst %,-I%, . $(INCLUDES_DIR))

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

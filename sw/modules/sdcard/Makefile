####################################################################
# Makefile							   #
####################################################################

.SUFFIXES:				# ignore builtin rules
.PHONY: all debug release clean

####################################################################
# Definitions							   #
####################################################################

DEVICE = EFM32GG990F1024
PROJECTNAME = copy-file

OBJ_DIR = build
EXE_DIR = exe
LST_DIR = lst

####################################################################
# Definitions of toolchain.					   #
# You might need to do changes to match your system setup	   #
####################################################################

# Change path to the tools according to your system configuration
# DO NOT add trailing whitespace chars, they do matter !
WINDOWSCS  ?= GNU Tools ARM Embedded\4.7 2012q4
LINUXCS	   ?= /usr/local/Cellar/gcc-arm-none-eabi/20121016
# /cad/arm-embedded/gcc-arm-none-eabi-4_7-2012q4

LIB=/Users/havard/Documents/programmering/c/TDT4295/sw/libs
DIR=/Users/havard/Documents/programmering/c/TDT4295/sw
#/Users/havard/Documents/Silabs

RMDIRS	   := rm -rf
RMFILES	   := rm -rf
ALLFILES   := /*.*
NULLDEVICE := /dev/null
SHELLNAMES := $(ComSpec)$(COMSPEC)

# Try autodetecting the environment
ifeq ($(SHELLNAMES),)
  # Assume we are making on a Linux platform
  TOOLDIR := $(LINUXCS)
else
  QUOTE :="
  ifneq ($(COMSPEC),)
    # Assume we are making on a mingw/msys/cygwin platform running on Windows
    # This is a convenient place to override TOOLDIR, DO NOT add trailing
    # whitespace chars, they do matter !
    TOOLDIR := $(PROGRAMFILES)/$(WINDOWSCS)
    ifeq ($(findstring cygdrive,$(shell set)),)
      # We were not on a cygwin platform
      NULLDEVICE := NUL
    endif
  else
    # Assume we are making on a Windows platform
    # This is a convenient place to override TOOLDIR, DO NOT add trailing
    # whitespace chars, they do matter !
    SHELL      := $(SHELLNAMES)
    TOOLDIR    := $(ProgramFiles)/$(WINDOWSCS)
    RMDIRS     := rd /s /q
    RMFILES    := del /s /q
    ALLFILES   := \*.*
    NULLDEVICE := NUL
  endif
endif

# Create directories and do a clean which is compatible with parallell make
$(shell mkdir $(OBJ_DIR)>$(NULLDEVICE) 2>&1)
$(shell mkdir $(EXE_DIR)>$(NULLDEVICE) 2>&1)
$(shell mkdir $(LST_DIR)>$(NULLDEVICE) 2>&1)
ifeq (clean,$(findstring clean, $(MAKECMDGOALS)))
  ifneq ($(filter $(MAKECMDGOALS),all debug release),)
    $(shell $(RMFILES) $(OBJ_DIR)$(ALLFILES)>$(NULLDEVICE) 2>&1)
    $(shell $(RMFILES) $(EXE_DIR)$(ALLFILES)>$(NULLDEVICE) 2>&1)
    $(shell $(RMFILES) $(LST_DIR)$(ALLFILES)>$(NULLDEVICE) 2>&1)
  endif
endif

CC	= $(QUOTE)$(TOOLDIR)/bin/arm-none-eabi-gcc$(QUOTE)
LD	= $(QUOTE)$(TOOLDIR)/bin/arm-none-eabi-ld$(QUOTE)
AR	= $(QUOTE)$(TOOLDIR)/bin/arm-none-eabi-ar$(QUOTE)
OBJCOPY = $(QUOTE)$(TOOLDIR)/bin/arm-none-eabi-objcopy$(QUOTE)
DUMP	= $(QUOTE)$(TOOLDIR)/bin/arm-none-eabi-objdump$(QUOTE)

####################################################################
# Flags								   #
####################################################################

# -MMD : Don't generate dependencies on system header files.
# -MP  : Add phony targets, useful when a h-file is removed from a project.
# -MF  : Specify a file to write the dependencies to.
DEPFLAGS = -MMD -MP -MF $(@:.o=.d)

#
# Add -Wa,-ahld=$(LST_DIR)/$(@F:.o=.lst) to CFLAGS to produce assembly list files
#
override CFLAGS += -D$(DEVICE) -Wall -Wextra -mcpu=cortex-m3 -mthumb \
-mfix-cortex-m3-ldrd -ffunction-sections \
-fdata-sections -fomit-frame-pointer -DDEBUG_EFM -std=c99 \
$(DEPFLAGS)

override ASMFLAGS += -x assembler-with-cpp -D$(DEVICE) -Wall -Wextra -mcpu=cortex-m3 -mthumb

#
# NOTE: The -Wl,--gc-sections flag may interfere with debugging using gdb.
#
override LDFLAGS += -Xlinker -Map=$(LST_DIR)/$(PROJECTNAME).map -mcpu=cortex-m3 \
-mthumb -T$(LIB)/Device/EnergyMicro/EFM32GG/Source/GCC/efm32gg.ld \
 -Wl,--gc-sections

LIBS = -Wl,--start-group -lgcc -lc -lnosys   -Wl,--end-group

#-I$(LIB)/kits/EFM32GG_STK3700/config \

INCLUDEPATHS += \
-I. \
-I./demo \
-I$(LIB)/CMSIS/Include \
-I$(LIB)/Device/EnergyMicro/EFM32GG/Include \
-I$(LIB)/emlib/inc \
-I$(LIB)/kits/common/bsp \
-I$(LIB)/kits/EFM32GG_DK3750/config \
-I$(LIB)/kits/common/drivers \
-I$(LIB)/emdrv/gpiointerrupt/inc \
-I$(LIB)/glib \
-I$(LIB)/fatfs/inc \
-I$(LIB)/usb/inc \
-I$(DIR)/modules/adc/inc \
-I$(DIR)/modules/dac/inc \
-I$(DIR)/modules/dma/inc \
-I$(DIR)/modules/prs/inc \
-I$(DIR)/modules/fpga/inc \
-I$(DIR)/modules/sdcard/inc \
-I$(LIB)/util/inc 


####################################################################
# Files								   #
####################################################################

# $(LIB)/kits/common/bsp/bsp_stk.c \
# $(LIB)/kits/common/bsp/bsp_stk_leds.c \

C_SRC +=  \
$(LIB)/Device/EnergyMicro/EFM32GG/Source/system_efm32gg.c \
$(LIB)/kits/common/bsp/bsp_bcc.c \
$(LIB)/kits/common/bsp/bsp_dk_3201.c \
$(LIB)/kits/common/bsp/bsp_dk_leds.c \
$(LIB)/kits/common/bsp/bsp_trace.c \
$(LIB)/kits/common/drivers/dmactrl.c \
$(LIB)/kits/common/drivers/microsd.c \
$(LIB)/kits/common/drivers/rtcdrv.c \
$(LIB)/fatfs/src/ff.c \
$(LIB)/fatfs/src/diskio.c \
$(LIB)/util/src/wav.c \
$(LIB)/util/src/fatfs_file.c \
$(LIB)/emlib/src/em_assert.c \
$(LIB)/emlib/src/em_adc.c \
$(LIB)/emlib/src/em_cmu.c \
$(LIB)/emlib/src/em_dac.c \
$(LIB)/emlib/src/em_dma.c \
$(LIB)/emlib/src/em_ebi.c \
$(LIB)/emlib/src/em_emu.c \
$(LIB)/emlib/src/em_gpio.c \
$(LIB)/emlib/src/em_int.c \
$(LIB)/emlib/src/em_prs.c \
$(LIB)/emlib/src/em_rtc.c \
$(LIB)/emlib/src/em_system.c \
$(LIB)/emlib/src/em_timer.c \
$(LIB)/emlib/src/em_usart.c \
$(DIR)/modules/sdcard/src/bl_sd.c \
$(LIB)/emdrv/gpiointerrupt/src/gpiointerrupt.c \
demo/$(PROJECTNAME).c



s_SRC +=

S_SRC +=  \
$(LIB)/Device/EnergyMicro/EFM32GG/Source/GCC/startup_efm32gg.S



####################################################################
# Rules								   #
####################################################################

C_FILES = $(notdir $(C_SRC) )

S_FILES = $(notdir $(S_SRC) $(s_SRC) )
#make list of source paths, sort also removes duplicates
C_PATHS = $(sort $(dir $(C_SRC) ) )
S_PATHS = $(sort $(dir $(S_SRC) $(s_SRC) ) )

C_OBJS = $(addprefix $(OBJ_DIR)/, $(C_FILES:.c=.o))
S_OBJS = $(if $(S_SRC), $(addprefix $(OBJ_DIR)/, $(S_FILES:.S=.o)))
s_OBJS = $(if $(s_SRC), $(addprefix $(OBJ_DIR)/, $(S_FILES:.s=.o)))
C_DEPS = $(addprefix $(OBJ_DIR)/, $(C_FILES:.c=.d))
OBJS = $(C_OBJS) $(S_OBJS) $(s_OBJS)

vpath %.c $(C_PATHS)
vpath %.s $(S_PATHS)
vpath %.S $(S_PATHS)

# Default build is debug build
#dbg: 
#	@echo $(C_FILES)

all:	  debug

debug:	  CFLAGS += -DDEBUG -O0 -g3
debug:	  $(EXE_DIR)/$(PROJECTNAME).bin

release:  CFLAGS += -DNDEBUG -O0 -g3
release:  $(EXE_DIR)/$(PROJECTNAME).bin

# Create objects from C SRC files
$(OBJ_DIR)/%.o: %.c
	@echo "Building file: $<"
	$(CC) $(CFLAGS) $(INCLUDEPATHS) -c -o $@ $<

# Assemble .s/.S files
$(OBJ_DIR)/%.o: %.s
	@echo "Assembling $<"
	$(CC) $(ASMFLAGS) $(INCLUDEPATHS) -c -o $@ $<

$(OBJ_DIR)/%.o: %.S
	@echo "Assembling $<"
	$(CC) $(ASMFLAGS) $(INCLUDEPATHS) -c -o $@ $<

# Link
$(EXE_DIR)/$(PROJECTNAME).out: $(OBJS)
	@echo "Linking target: $@"
	$(CC) $(LDFLAGS) $(OBJS) $(LIBS) -o $(EXE_DIR)/$(PROJECTNAME).out

# Create binary file
$(EXE_DIR)/$(PROJECTNAME).bin: $(EXE_DIR)/$(PROJECTNAME).out
	@echo "Creating binary file"
	$(OBJCOPY) -O binary $(EXE_DIR)/$(PROJECTNAME).out $(EXE_DIR)/$(PROJECTNAME).bin
# Uncomment next line to produce assembly listing of entire program
#	$(DUMP) -h -S -C $(EXE_DIR)/$(PROJECTNAME).out>$(LST_DIR)/$(PROJECTNAME)out.lst

clean:
ifeq ($(filter $(MAKECMDGOALS),all debug release),)
	$(RMDIRS) $(OBJ_DIR) $(LST_DIR) $(EXE_DIR)
endif

# include auto-generated dependency files (explicit rules)
ifneq (clean,$(findstring clean, $(MAKECMDGOALS)))
-include $(C_DEPS)
endif

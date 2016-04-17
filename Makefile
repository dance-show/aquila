###############################################################################
#  Copyright (C) 2014-2015
#  file:    Makefile
#  author:  gozfree <gozfree@163.com>
#  created: 2016-04-17 18:37
#  updated: 2016-04-17 18:37
###############################################################################

###############################################################################
# common
###############################################################################
#ARCH: linux/pi/android/ios/
ARCH		?= linux
CROSS_PREFIX	?=
OUTPUT		?= /usr/local
BUILD_DIR	:= $(shell pwd)/../build/
ARCH_INC	:= $(BUILD_DIR)/$(ARCH).inc
COLOR_INC	:= $(BUILD_DIR)/color.inc

ifeq ($(ARCH_INC), $(wildcard $(ARCH_INC)))
include $(ARCH_INC)
endif

CC	= $(CROSS_PREFIX)gcc
CXX	= $(CROSS_PREFIX)g++
LD	= $(CROSS_PREFIX)ld
AR	= $(CROSS_PREFIX)ar

ifeq ($(COLOR_INC), $(wildcard $(COLOR_INC)))
include $(COLOR_INC)
else
CC_V	= $(CC)
CXX_V	= $(CXX)
LD_V	= $(LD)
AR_V	= $(AR)
CP_V	= $(CP)
RM_V	= $(RM)
endif

###############################################################################
# target and object
###############################################################################
TGT_NAME 	= aquila
###############################################################################
# cflags and ldflags
###############################################################################
CFLAGS_SDL	= `pkg-config --cflags sdl`
LDFLAGS_SDL	= `pkg-config --libs sdl`
LDFLAGS_X264	= -lx264
LDFLAGS_ALSA	= -lasound
LDFLAGS_FFMPEG	= `pkg-config --libs libavformat libavutil libavcodec libswscale`

CFLAGS	:= -g -Wall -Werror
CFLAGS	+= -I$(OUTPUT)/include -I./
CFLAGS	+= -I./algo
CFLAGS	+= -I./codec
CFLAGS	+= -I./device
CFLAGS	+= -I./playback
CFLAGS	+= -I./protocol
CFLAGS	+= -I./util
CFLAGS	+= $(CFLAGS_SDL)

LDFLAGS	:=
LDFLAGS	+= -lgcc_s -lc
LDFLAGS += -L$(OUTPUT)/lib
LDFLAGS	+= -lpthread -lrt
LDFLAGS	+= $(LDFLAGS_SDL)
LDFLAGS	+= $(LDFLAGS_X264)
LDFLAGS += $(LDFLAGS_ALSA)
LDFLAGS += $(LDFLAGS_FFMPEG)

.PHONY : all clean

TGT	:= $(TGT_NAME)

ALGO_OBJS :=

CODEC_OBJS :=

DEVICE_OBJS :=

PLAYBACK_OBJS :=

PROTOCOL_OBJS :=

UTIL_OBJS :=

OBJS := \
    $(ALGO_OBJS) \
    $(CODEC_OBJS) \
    $(DEVICE_OBJS) \
    $(PLAYBACK_OBJS) \
    $(PROTOCOL_OBJS) \
    $(UTIL_OBJS) \
    main.o

all: $(TGT)

%.o:%.c
	$(CC_V) -c $(CFLAGS) $< -o $@

$(TGT_NAME): $(OBJS)
	$(CC_V) -o $@ $^ $(LDFLAGS)

clean:
	$(RM_V) -f $(OBJS)
	$(RM_V) -f $(TGT)

install:
	$(CP_V) -f $(TGT_NAME) ${OUTPUT}/bin

uninstall:
	$(RM_V) -f ${OUTPUT}/bin/$(TGT_NAME)


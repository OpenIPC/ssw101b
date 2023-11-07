#############################################################################
PWD := $(shell pwd)
WIFI_INSTALL_DIR := $(PWD)/output

NOSTDINC_FLAGS := -I$(src)/include/ \
	-include $(src)/include/linux/compat-2.6.h \
	-DCOMPAT_STATIC

#####################################################
export
MODULES_NAME = ssw101b_wifi_usb
CONFIG_FPGA = n
CONFIG_1601 = n
CONFIG_1606 = n
CONFIG_APOLLOC = n
CONFIG_APOLLOD = n
CONFIG_APOLLOE = n
CONFIG_ATHENAA = n
CONFIG_ATHENAB = n
CONFIG_ATHENAB_24M = n
CONFIG_ATHENAC = n
CONFIG_ATHENALITE = n
CONFIG_ATHENALITE_ECO = n
CONFIG_ARES = n
CONFIG_ARESB = y
CONFIG_HERA = n
USB_BUS = y
SPI_BUS = n
SDIO_BUS = n
TX_NO_CONFIRM = n
MULT_NAME = n
SSTAR_MAKEFILE_SUB = y

LOAD_FW_H = y
SKB_DEBUG = n
MEM_DEBUG = n
BRIDGE = n
MONITOR = y
EARLYSUSPEND = n
CH5G = y
USBAGGTX = y
NOTXCONFIRM = y
USBDMABUFF = y
USBCMDENHANCE = y
USBDATAENHANCE = y
PMRELODDFW = n
CHECKSUM = n
CONFIG_NOT_SUPPORT_40M_CHW = n

##################################################
ifeq ($(CONFIG_HERA),y)
SDIO_BUS = y
endif

#####################################################
export 
ifeq ($(CONFIG_SSTAR_APOLLO),)
CONFIG_SSTAR_APOLLO = m
endif

export
include $(src)/Makefile.build.kernel

export
SSTAR_WIFI__EXT_CCFLAGS = -DSSTAR_WIFI_PLATFORM=18

#####################################################
export
ifeq ($(CONFIG_MAC80211_SSTAR_RC_MINSTREL),)
SSTAR_WIFI__EXT_CCFLAGS += -DCONFIG_MAC80211_SSTAR_RC_MINSTREL=1
CONFIG_MAC80211_SSTAR_RC_MINSTREL = y
endif

ifeq ($(CONFIG_MAC80211_SSTAR_RC_MINSTREL_HT),)
SSTAR_WIFI__EXT_CCFLAGS += -DCONFIG_MAC80211_SSTAR_RC_MINSTREL_HT=1
CONFIG_MAC80211_SSTAR_RC_MINSTREL_HT = y
endif

ifeq ($(USB_BUS),y)
HIF := usb
endif

ifeq ($(SDIO_BUS),y)
HIF := sdio
endif

ifeq ($(SPI_BUS),y)
HIF := spi
endif

modules:					
	$(MAKE) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) -C $(KDIR) M=$(shell pwd) modules -j8

strip:
	$(CROSS_COMPILE)strip $(WIFI_INSTALL_DIR)/$(MODULES_NAME).ko --strip-unneeded

clean:
	make -C $(KDIR) M=$(PWD) ARCH=$(ARCH) clean

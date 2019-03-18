
include ../Makefile.kern

# for a specific linux version uncomment
#KSOURCE_PATH             = /usr/src/linux-4.14.23-gentoo

# Architecture and crosscompile prefix
export ARCH              = arm

ifneq ($(KHOST),$(shell hostname))
  export CROSS_COMPILE     = armv7a-unknown-linux-gnueabihf-
endif

# Change make targets
KMAKE_INSTALL_TARGETS    = zinstall modules_install
KMAKE_TARGETS           += dtbs

# Treating dtb files seperately:
DTB_FILES                = exynos5422-odroidhc1.dtb
DTB_TARGETS_DIR          = $(IMAGE_PATH)/boot/dtbs

$(DTB_FILES): kimage
	@KERNELRELEASE=`cat $(IMAGE_PATH)/$(INFO_PATH)/kernelrelease` ; \
	[[ ! -e $(DTB_TARGETS_DIR)/$$KERNELRELEASE ]] && $(call RUNCMD,install -d $(DTB_TARGETS_DIR)/$$KERNELRELEASE); \
	$(call RUNCMD,install -m644 $(KBUILD_OUTPUT)/arch/$(ARCH)/boot/dts/$@ $(DTB_TARGETS_DIR)/$$KERNELRELEASE)

# image depends on the dtb files
image: $(DTB_FILES)

.PHONY: $(DTB_FILES)


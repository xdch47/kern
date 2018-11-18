
# Architecture and crosscompile prefix
export ARCH              = arm

ifneq ($(KHOST),$(shell hostname))
  export CROSS_COMPILE   = armv7a-unknown-linux-gnueabihf-
endif

# Change make targets
KMAKE_INSTALL_TARGETS    = zinstall modules_install
KMAKE_TARGETS            = bzImage dtbs modules

# Treating dtb files seperately:
DTB_FILES                = exynos5422-odroidhc1.dtb
DTB_TARGETS_DIR          = $(IMAGE_PATH)/boot/dtbs

build: create_kernel_release_info

create_kernel_release_info: kbuild
	@$(call RUNCMD,$(SHELL) -c "make -sC $(KSOURCE_PATH) kernelrelease > $(IMAGE_PATH)/$(INFO_PATH)/kernelrelease")

$(DTB_FILES): kimage
	@KERNELRELEASE=`cat $(IMAGE_PATH)/$(INFO_PATH)/kernelrelease` ; \
	[[ ! -e $(DTB_TARGETS_DIR)/$$KERNELRELEASE ]] && $(call RUNCMD,install -d $(DTB_TARGETS_DIR)/$$KERNELRELEASE); \
	$(call RUNCMD,install $(KBUILD_OUTPUT)/arch/$(ARCH)/boot/dts/$@ $(DTB_TARGETS_DIR)/$$KERNELRELEASE)

# image depends on the dtb files
image: $(DTB_FILES)

.PHONY: $(DTB_FILES) create_kernel_release_info

include ../Makefile.kern

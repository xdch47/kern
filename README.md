
# PURPOSE

This is a simple Makefile wrapper around the kernel makefile,
which enables the following advantages:

1. Seperate kernel-sources and kernel-build objects:
    * allows *reuse of source files* for different kernel configuration

2. Fast/painless compile and install process:
   * `make` ; `make install` (or `make gentooinstall`) is enough
   * nice level and makeflags are supported
   * remote host installation possible  -- check the `SSH_INSTALL_USER` / `SSH_HOST_INSTALL` variables

3. optional: build kernel as [portage] user
    * use a root shell uncomment/set `KBUILD_USER` in `Makefile.kern` (global) or in your `Makefile` for a local config (`sudo` is necessary)
    * ensure that the user has the permissions to create the build directory

It's especially dedicated to gentoo-users, but should works (with minor adpations) for all others distros as well.
However there is a `gentooinstall` target which covers additionally:

* grub-mkconfig -o /boot/grub/grub
* emerge -1 @module-rebuild

# USAGE

`Makefile.kern` is kind of the template makefile.
For a standard (amd64/x86) compilation the following steps are necessary:

Initial:

* Create a directory (favored use the name of the host the kernel is used) otherwise set `KHOST` variable 
* Create a Makefile and adapt special configuration settings like `KSOURCE_PATH`, `KMAKE_TARGETS` etc.
* Finally include the template makefile by adding `include ../Makefile.kern`
* (optional) add a intial kernel configuration in a `defconfig` file (in case the file is missing make defconfig is used)

Compilation:

* (optional) run `make update_defconfig` in order to update your kernel seed from the currently running kernel (access to /proc/config.gz required)
* (optional) run other kernel tragets like `make menuconfig`
* run `make'

Installation:

* run `make install` (or `make gentooinstall`)

# EXAMPLES

* amd64: look at the `amd64-host-example/` directory
* armv7a: look at the `armv7a-odroidhc1-example/` directory


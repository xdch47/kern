#!/bin/bash

die() {
    echo $1
    exit 1
}

lddtree_copy() {
    lddtree $(which $1) --copy-to-tree ${IMAGE_DIR} || die "ERROR: Failed to copy $1."
}

IMAGE_DIR=build/${1:-initramfs-linux}

[[ -d $IMAGE_DIR ]] && die "Directory $IMAGE_DIR already exists."

mkdir -p $IMAGE_DIR

# busybox
lddtree_copy busybox
# udhcpc scripts
install -D /usr/share/udhcpc/default.script ${IMAGE_DIR}/usr/share/udhcpc/default.script

lddtree_copy cryptsetup
lddtree_copy dropbear
#lddtree_copy mkimage

# custom-files
cp -ar ./custom-files/* ${IMAGE_DIR}

# libnss_files
mkdir -p ${IMAGE_DIR}/lib64

if [[ -e /lib64/libnss_files.so.2 ]] ; then
    cp -a /lib64/libnss_files.so.2 ${IMAGE_DIR}/lib64
    cp $(readlink -e /lib/libnss_files.so.2) ${IMAGE_DIR}/lib64
fi



#!/bin/bash

firmware=(i915/skl_dmc_ver1_27.bin i915/skl_guc_ver6_1.bin)

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
# base layout
if [[ $(uname -m) = "x86_64" ]] ; then
    #mkdir -p $IMAGE_DIR/usr/lib
    #ln -s usr/lib $IMAGE_DIR/lib

    mkdir -p $IMAGE_DIR/usr/lib64
    ln -s usr/lib64 $IMAGE_DIR/lib64
else
    mkdir -p $IMAGE_DIR/lib
fi
mkdir -p $IMAGE_DIR/usr/{bin,sbin}
ln -s usr/bin $IMAGE_DIR/bin
ln -s usr/sbin $IMAGE_DIR/sbin

# firmware
for f in ${firmware[@]} ; do
    mkdir -p $IMAGE_DIR/lib/firmware/${f%/*}
    cp /lib/firmware/$f $IMAGE_DIR/lib/firmware/$f
done

# busybox
lddtree_copy busybox
# udhcpc scripts
install -D /usr/share/udhcpc/default.script ${IMAGE_DIR}/usr/share/udhcpc/default.script

# console font
#install -D /usr/share/consolefonts/ter-112n.psf.gz ${IMAGE_DIR}/usr/share/consolefonts/ter-112n.psf.gz

lddtree_copy cryptsetup
lddtree_copy dropbear
#lddtree_copy mkimage

# custom-files
cp -ar ./custom-files/* ${IMAGE_DIR}

# libnss_files
mkdir -p ${IMAGE_DIR}/lib64

if [[ -e /lib64/libnss_files.so.2 ]] ; then
    cp -a /lib64/libnss_files.so.2 ${IMAGE_DIR}/lib64
    cp $(readlink -e /lib64/libnss_files.so.2) ${IMAGE_DIR}/lib64
fi

# Include libgcc_s.so.1 for libpthread.so
# copied from https://code.funtoo.org/bitbucket/projects/MISC/repos/genkernel-funtoo/browse/gen_initramfs.sh
if type gcc-config 2>&1 1>/dev/null; then
    libgccpath="/usr/lib/gcc/$(s=$(gcc-config -c); echo ${s%-*}/${s##*-})/libgcc_s.so.1"
fi
if [[ ! -f ${libgccpath} ]]; then
    libgccpath="/usr/lib/gcc/*/*/libgcc_s.so.1"
fi


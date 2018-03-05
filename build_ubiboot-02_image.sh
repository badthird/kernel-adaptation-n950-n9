#!/bin/bash
rm -rf ./usr/built-in.o usr/initramfs_data.cpio ./usr/initramfs_data.o ./arch/arm/boot/zImage ./arch/arm/boot/Image ./lib/modules/
make clean
make mrproper
ARCH=arm make ubiboot-02_defconfig
ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- make
ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- make modules
cp ./arch/arm/boot/zImage ./zImage_2.6.32.54-ubiboot-02_$(date +%d%m%Y)



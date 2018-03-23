#!/bin/bash
set -e
modstart=$(cat -n ubifs/ubifs_list | grep START_MODULES_BLOCK | cut -f 1)
modstart=$(echo "$modstart + 1" | bc)
modend=$(cat -n ubifs/ubifs_list | grep END_MODULES_BLOCK | cut -f 1)
modend=$(echo "$modend - 1" | bc)
rm -rf ./usr/built-in.o usr/initramfs_data.cpio ./usr/initramfs_data.o ./arch/arm/boot/zImage ./arch/arm/boot/Image
make clean
make mrproper
ARCH=arm make ubiboot-02_defconfig
for lnum in $(seq $modstart $modend); do sed -i "$lnum s/^/#/" ubifs/ubifs_list; done
ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- make
ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- make modules
for lnum in $(seq $modstart $modend); do sed -i "$lnum s/^#//" ubifs/ubifs_list; done
rm -rf ./usr/built-in.o usr/initramfs_data.cpio ./usr/initramfs_data.o ./arch/arm/boot/zImage ./arch/arm/boot/Image
ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- make
cp ./arch/arm/boot/zImage ./zImage_2.6.32.54-ubiboot-02_$(date +%d%m%Y)


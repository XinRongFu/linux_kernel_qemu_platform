#!/bin/sh
#Modify the input option for modinfo in /usr/lib/dracut/dracut-functions (/home/sean/work/source/upstream/kernel.org/initramfs)
#Arguments: src_directory kernelrelease
#KERNEL_RELEASE_VER=$1
QEMU_UPSTREAM_ROOT=$1
INITRD_PATH="/home/sean/work/source/upstream/kernel.org/initramfs"
QEMU_PLATFORM_PATH="/home/sean/work/source/upstream/kernel.org/"

build_kernel()
{
	cd $QEMU_UPSTREAM_ROOT/linux
	#make clean
	make all -j4
	make bzImage -j4
	make modules -j4
	make modules_install INSTALL_MOD_PATH=$INITRD_PATH
}

get_kernel_ver()
{
	cd $QEMU_UPSTREAM_ROOT/linux
	KERNEL_RELEASE_VER=`make kernelrelease`
	echo $KERNEL_RELEASE_VER
}


build_initrd()
{
	cd $QEMU_UPSTREAM_ROOT/linux
	cp arch/x86/boot/bzImage $QEMU_PLATFORM_PATH/qemu_platform/
	cd $QEMU_PLATFORM_PATH/qemu_platform
	rm initrd-$KERNEL_RELEASE_VER
	./creat_initram_rel.sh $KERNEL_RELEASE_VER
	mount /home/sean/sda5/image/hda_10g.img ./hda_ext4
	rm -rf ./hda_ext4/lib/modules/*
	cp -a -P $INITRD_PATH/lib/modules/$KERNEL_RELEASE_VER ./hda_ext4/lib/modules/
	sync
	umount ./hda_ext4
}

run_guest()
{
	cd $QEMU_PLATFORM_PATH
#	cd QEMU_UPSTREAM_ROOT/linux
	echo "./qemu-kvm-kernel_rel.sh $KERNEL_RELEASE_VER $1 $#"
	./qemu-kvm-kernel_rel.sh $KERNEL_RELEASE_VER debug
}

case "$2" in
	kernel)
		build_kernel
		;;
	initrd) 
		get_kernel_ver
		build_initrd
		;;
	version)
		get_kernel_ver
		;;
	all)
		build_kernel
		get_kernel_ver
		build_initrd
		;;
	run) 
		get_kernel_ver
		run_guest $@
		;;
	*)
		echo "Usage: build_all.sh kernel_src_path {kernel|initrd|version|all|run}"
		exit 1
esac


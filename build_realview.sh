#!/bin/bash
export CPUS=`grep -c processor /proc/cpuinfo`
export ARCH=arm
export CROSS_COMPILE=/opt/toolchain/bin/arm-linux-

do_build_debug()
{
	if [ $# -lt 1 ]; then
		echo "input few args ..."
		exit
	fi
	case $1 in
		-b)
			make  O=output realview-smp_defconfig
			make  O=output -j${CPUS}
		;;
		-c)
			make -C output clean
		;;
		-r)
			qemu-system-arm -M realview-eb-mpcore -cpu arm11mpcore \
			-kernel output/arch/arm/boot/zImage \
			-sd rootfs.ext2 \
			-append "console=ttyAMA0,115200 init=/linuxrc root=/dev/mmcblk0 rw rootwait" \
			-serial stdio  -show-cursor
		;;

		-d)
			qemu-system-arm -M versatilepb \
			-kernel output/arch/arm/boot/zImage \
			-sd rootfs.ext2 \
			-append "console=ttyAMA0,115200 init=/linuxrc root=/dev/mmcblk0 rw rootwait" \
			-serial stdio  -show-cursor \
			-S -s
		;;
		*)
			;;
	esac
}

do_build_debug $1

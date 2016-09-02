#!/bin/sh
#
ARCH=$(uname -m)

config="cavium_octeon_defconfig"

build_prefix="-mips3-x"
branch_prefix="v"
branch_postfix=".x"

#arm
KERNEL_ARCH=arm
#toolchain="gcc_linaro_gnueabihf_6"
#toolchain="gcc_unknown_linux_gnueabi"
#toolchain="gcc_unknown_linux_gnu"
toolchain="gcc_sourcery_mips_4_8"

#Kernel/Build
KERNEL_REL=4.8
KERNEL_TAG=${KERNEL_REL}-rc4
BUILD=${build_prefix}1
kernel_rt=""

#v4.X-rcX + upto SHA
#prev_KERNEL_SHA=""
#KERNEL_SHA=""

#git branch
BRANCH="${branch_prefix}${KERNEL_REL}${branch_postfix}"

DISTRO=cross
DEBARCH=mips
#

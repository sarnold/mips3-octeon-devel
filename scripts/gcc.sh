#!/bin/sh -e
#
# Copyright (c) 2009-2016 Robert Nelson <robertcnelson@gmail.com>
# MIPS changes copyright (c) 2016 Stephen L Arnold <nerdboy@gentoo.org>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

ARCH=$(uname -m)
DIR=$PWD

. "${DIR}/system.sh"

#For:
#toolchain
. "${DIR}/version.sh"

if [  -f "${DIR}/.yakbuild" ] ; then
	. "${DIR}/recipe.sh"
fi

if [ -d $HOME/dl/gcc/ ] ; then
	gcc_dir="$HOME/dl/gcc"
else
	gcc_dir="${DIR}/dl"
fi

dl_gcc_generic () {
	WGET="wget -c --directory-prefix=${gcc_dir}/"
	if [ ! -f "${gcc_dir}/${directory}/${datestamp}" ] ; then
		echo "Installing: ${toolchain_name}"
		echo "-----------------------------"
# currently no alternate archive site
#		${WGET} "${site}/${version}/${filename}" || ${WGET} "${archive_site}/${version}/${filename}"
		${WGET} "${site}/${version}/${filename}"
		if [ -d "${gcc_dir}/${directory}" ] ; then
			rm -rf "${gcc_dir}/${directory}" || true
		fi
		tar -xf "${gcc_dir}/${filename}" -C "${gcc_dir}/"
		if [ -f "${gcc_dir}/${directory}/${binary}gcc" ] ; then
			touch "${gcc_dir}/${directory}/${datestamp}"
		fi
	fi

	if [ "x${ARCH}" = "xarmv7l" ] ; then
		#using native gcc
		CC=
	else
		CC="${gcc_dir}/${directory}/${binary}"
	fi
}

gcc_toolchain () {
	site="https://sourcery.mentor.com"
#	archive_site="https://releases.linaro.org/archive"
	case "${toolchain}" in
	gcc_sourcery_mips_4_8)
		#
		#https://sourcery.mentor.com/GNUToolchain/package12215/public/mips-linux-gnu/mips-2013.11-36-mips-linux-gnu-i686-pc-linux-gnu.tar.bz2
		#

		gcc_version="4.8"
		release="2013.11-36"
		target="mips-linux-gnu"

		version="GNUToolchain/package12215/public/${target}"
		filename="mips-${release}-${target}-i686-pc-linux-gnu.tar.bz2"
		directory="mips-2013.11"
		datestamp="${release}-${target}"
		binary="bin/${target}-"
		;;

	*)
		echo "bug: maintainer forgot to set:"
		echo "toolchain=\"xzy\" in version.sh"
		exit 1
		;;
	esac

	dl_gcc_generic
}

unset check
if [ "x${KERNEL_ARCH}" = "xmips" ] ; then
	check="mips"
fi

GCC_TEST=$(LC_ALL=C "${CC}gcc" -v 2>&1 | grep "Target:" | grep ${check} || true)

if [ "x${GCC_TEST}" = "x" ] ; then
	echo "-----------------------------"
	echo "scripts/gcc: Error: The GCC Cross Compiler you setup in system.sh (CC variable) is invalid."
	echo "-----------------------------"
	gcc_toolchain
fi

echo "-----------------------------"
echo "scripts/gcc: Using: $(LC_ALL=C "${CC}"gcc --version)"
echo "-----------------------------"
echo "CC=${CC}" > "${DIR}/.CC"

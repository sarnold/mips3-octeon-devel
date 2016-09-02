mips3-octeon-devel
==================

This is just a set of scripts to rebuild a known working kernel for MIPS devices, mainly Cavium Octeon Edgerouter Lite, etc.  Shamelessly forked and modified from Robert Nelson's ARM build scripts.

Script Bugs:

Please use the github issue tracker to report any bugs.

Dependencies: GCC MIPS Cross ToolChain

Mentor MIPS toolchain:
https://sourcery.mentor.com/GNUToolchain/release2640

Dependencies: Linux Kernel Source

This git repo contains just scripts/patches to build a specific kernel for some
MIPS devices. The kernel source will be downloaded when you run any of the build
scripts.

By default this script will clone the linux-stable tree:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
to: ${DIR}/ignore/linux-src:

If you've already cloned torvalds tree and would like to save some hard drive
space, just modify the LINUX_GIT variable in system.sh to point to your current
git clone directory.

Setup:

Copy system.sh.sample to system.sh and edit for your own toolchain and location of the linux-stable repo.

Build Kernel Image::

    ./build_kernel.sh

Optional:

Build Debian Package::

    ./build_deb.sh

Development/Hacking:

First run (to setup baseline tree)::

    ./build_kernel.sh

then modify files under KERNEL directory and re-run (to rebuild with your changes)::

    ./tools/rebuild.sh


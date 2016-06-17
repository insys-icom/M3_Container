These directories and files help to create new containers.

The plan is:

1) Install a cross compiler
2) Clone this repository with build scripts
3) Use the cross compiler in combination with the build scripts from this repo to create new binaries and a new container


1) Install a cross compiler
---------------------------
The cross compiler and its toolchain must be for armv7 with hardware floating point support (armv7-hf).
There are several possibilities to achive this:
   - Use the INSYS SDK
   - in case you already use Gentoo on your host, install a cross compiler using "crossdev"
   - get another Toolchain (e.g. Ubuntu, Linaro, buildroot)


a) Use INSYS SDK
This is the recommended path to go. In fact it is a virtual Machine (VirtualBox) containing a tiny Gentoo Linux distribution and the crossdev target armv7-hf.
    - install VirtualBox
    - download Image: https://

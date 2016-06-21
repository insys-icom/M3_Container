The files within this repository help to create new binaries and containers.

The plan is:

1. Get build scripts
2. Install a SDK
3. Use both


To get most of the OpenSource projects compiled you need a cross compiler, a linker and some other tools. They are located within the SDK (Software Development Kit). These scripts can "configure", "make" and "make install" projects. The result can be packed to a container that can be uploaded onto a router.


1 Get build scripts
-------------------
This repository is all about build scripts. Most likely you already have gotten this repo, as you are reading this text. If this is not the case you get this repository by typing: `> git clone git@github.com:insys-icom/M3_Container.git`


2 Install a SDK
---------------
The cross compiler and its toolchain must be for ARMv7 architecture with hardware floating point support (armv7-hf).
There are several possibilities to achive get a cross toolchain:  
* Use the INSYS SDK (recommended)
* In case you use Gentoo on your host: install a cross compiler using "crossdev"
* Get another toolchain (e.g. Ubuntu, Linaro, buildroot ...)

It is recommended to use the INSYS SDK. Get it from https://www.insys-icom.de/data/smartbox/M3_SDK_2.ova. The SDK is a virtual Machine (VirtualBox) containing a tiny Gentoo Linux distribution and the crossdev target armv7-hf.
A more detailed installation instruction can be found in ./doc/Install_Virtualbox.md.


3 Use both
----------
The cross compiler in combination with the build scripts from this repo create new binaries and a new container.

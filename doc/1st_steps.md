The files within this repository help to create containers and ease cross compiling.


1 Install a SDK
---
The cross compiler and its toolchain must be for ARMv7 architecture with hardware floating point support (armv7-hf).
There are several possibilities to get a cross toolchain:

* Use the [SDK as LXC container](https://m3-container.net/M3_Container/SDK/M3_SDK_LXC.tar.gz) on a Linux host machine (recommended).
* Use the [SDK as VirtualBox image](https://m3-container.net/M3_Container/SDK/M3_SDK.ova) on any host machine supporting VirtualBox (like "Windows").
* In case you use Gentoo on your host: install a cross compiler using "crossdev".
* Get another toolchain (e.g. Ubuntu, Linaro, buildroot ...).

It is recommended to use the prepared SDK. It's a tiny Gentoo Linux with installed crossdev target armv7-hf. More detailed instructions:

* Install the SDK as [LXC container](Install_SDK_as_LXC_container.md)
* Install the SDK as [VirtualBox image](Install_VirtualBox.md)


2 Get build scripts into the SDK
---
This repository is all about build scripts. Most likely you already have cloned this repository, as you are reading this text. If that's not the case log into the SDK (console or ssh) and clone this repository by typing:
<pre>
    $ ssh user@IP-address-of-SDK
    $ git clone https://github.com/insys-icom/M3_Container.git
</pre>


3 Use the scripts
---
The cross compiler in combination with the build scripts from this repository create new binaries and a new container. This will create a default container:
<pre>
    $ cd M3_Container
    $ ./scripts/create_container_default.sh
</pre>
The scripts will download all needed open source packets from the internet and compile an update packet with the container to be installed on an M3 device.

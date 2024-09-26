The files within this repository help to create containers and ease cross compiling.


1 Install a SDK
---
You need a cross compiler for armv7:
* Use the [SDK as LXC container](https://m3-container.net/M3_Container/SDK/M3_SDK_LXC.tar.gz) on a Linux host machine (recommended).
* Use the [SDK as Docker image](Install_SDK_as_Docker_container.md) by transforming the LXC image into a docker image.
* In case you use Gentoo on your host: install a cross compiler using "crossdev".
* Get another toolchain (e.g. Yocto, Linaro, buildroot ...).

It is recommended to use the prepared SDK. It's a tiny Gentoo Linux with installed crossdev targets to cross compile. More detailed instructions how to install the SDK as [LXC container](Install_SDK_as_LXC_container.md)


2 Get build scripts into the SDK
---
This repository is all about build scripts. Clone this directly into the SDK or preverably clone it to your host and mount it into the SDK container:
<pre>
    $ ssh user@IP-address-of-SDK
    $ git clone https://github.com/insys-icom/M3_Container.git
</pre>


3 Use the scripts
---
The cross compiler in combination with the build scripts from this repository create new binaries and a new containers, e.g. the default demo container:
<pre>
    $ cd M3_Container
    $ ./scripts/create_container_default.sh
</pre>
The scripts will do everything to create a container from scratch: download all needed open source packets, configure, compile and install everything. Finally create the container as an Update Packet that can get uploaded an M3 device.

Be aware of the options of this script:
* -a <ARCH\>: compile for a different architecture, armv7 or amd64
* -b: build all sources and pack the container
* -p: pack the container without building the sources

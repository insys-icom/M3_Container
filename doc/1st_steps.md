The files within this repository help to create containers and ease cross compiling.


1 Install a SDK
---
The cross compiler and its toolchain must be for ARMv7 architecture with hardware floating point support (armv7-hf).
There are several possibilities to get a cross toolchain:  

* Use the INSYS [SDK](https://www.insys-icom.de/data/smartbox/M3_SDK_2.ova) (recommended)
* In case you use Gentoo on your host: install a cross compiler using "crossdev"
* Get another toolchain (e.g. Ubuntu, Linaro, buildroot ...)

It is recommended to use the INSYS SDK. It's a virtual Machine ([VirtualBox](https://virtualbox.org)) with a tiny Gentoo Linux distribution and the crossdev target armv7-hf. More detailed instructions are [here](doc/Install_VirtualBox.md "doc/Install_VirtualBox.md").


2 Get build scripts into the SDK
---
This repository is all about build scripts. Most likely you already have gotten this repository, as you are reading this text. If that's not the case log into the SDK (console or ssh) and clone this repository by typing:
<pre>
    $ ssh user@IP-address-of-SDK
    $ git clone git@github.com:insys-icom/M3_Container.git
</pre>


3 Use the scripts
---
The cross compiler in combination with the build scripts from this repository create new binaries and a new container. This will crate a default container:
<pre>
    $ cd M3\_Container
    $ ./scripts/mk_container.sh
</pre>
The scripts will download all needed open source packetets from the internet and compile an update packet with the container. This update packet will be stored in ./images.

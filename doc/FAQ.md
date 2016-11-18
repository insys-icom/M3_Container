FAQ - Frequently Asked Questions
================================

I imported a container on my router - how can I access it?
------------------------------------------------------------
Most of the times a fresh container contains an SSH or telnet server. There will be a user with user name "root" and password "root". It is strongly recommended to change the root password with the command "passwd". It is also a good idea to add another user for further operations.

Why is there no /dev in my container rootfs?
----------------------------------------------
The routers firmware will check if /dev exists within the rootfs of the container. If that is not the case, the router will create the directory and all necessary device nodes on its own. This is to enable non-root users to pack a container. Dealing with /dev and its device nodes require root permissions. This should not be necessary for packing a container.

Can I develop containers on Windows?
--------------------------------------
Yes, but there are limitations. Windows file systems do not know basic stuff like symlinks or detailed file permissions. Thatfore some of the open source project will not cross compile out of the box (like "busybox"). Packing a container also requires symlinks and the ability to set the read/write/execute bits. If you have nothing else apart from Windows, you will have to have all sources within the virtual machine with the C/C++ SDK.

There are other programming languages, which do not need a cross compiler like Python or Go. Using one of these and use the routers capabilities to export containers and you will be fine.

Can I use the already existing /media/sf_M3_Container in my VM?
-----------------------------------------------------------------
There could be a problem with the Group and User IDs that will prevent write permission. To avoid this it is recomended to let the SDK mount the shared folder (as described in "Install_Virtualbox.md").

Why fails compiling busybox with "read-only filesystem"?
----------------------------------------------------------
VirtualBox does not allow to follow symlinks as a security measure to avoid, that users leave the Shared Folder. You must allow following symlinks. Stop the SDK and use `> VBoxManage setextradata "VM_NAME" VBoxInternal2/SharedFoldersEnableSymlinksCreate/"SHARED" 1`

How should I begin with my own C/C++ application development?
---------------------------------------------------------------
Have a look at ./closed_source/hello_world. Use this as a template for your own application. Do not forget to enter your binary in the rootfs list (./scripts/rootfs_lists/default.txt), so your application will be included next time you pack a container.

The VM is slow/uncomfortable/etc, do I have to use this?
----------------------------------------------------------
No, absolutely not. The SDK should be a reference. It should be most robust, light weight and flexible. It is not the most performant or comfortable way to cross compile. Alternatives:
- Use a native Gentoo Linux with its crossdev
- Extend the content of the SDK (X11, window mangager, editor) to a full desktop machine and develop completely within the VM
- Use any other ARMv7-hf toolchain:
    - [https://buildroot.org](https://buildroot.org)
    - [http://crosstool-ng.org](http://crosstool-ng.org)
    - [http://www.acmesystems.it/arm0_toolchain](http://www.acmesystems.it/arm9_toolchain)
    - [https://www.yoctoproject.org](https://www.yoctoproject.org/)
- use LXC on your linux PC: startup the SDK from a external boot medium, pack all content, extract it to your host and add a lxc.conf file. Automount your M3_Container directory and compile without the overhead of a real virtual machine.

Where do I get a build script for the open source project X version Y?
------------------------------------------------------------------------
Make one yourself and share it via github! This applies also in case a build script exists, but there is a newer version of the project or you need modified compile options. Go to github, fork the repository, add or change build scripts and add a new pull request on github.
There is already a template "./oss_sources/scripts/template.sh" as a basic script.

FAQ - Frequently Asked Questions
================================

1 Why is there no /dev in my container rootfs?
----------------------------------------------
The routers firmware will check if /dev exists within the rootfs of the container. If that is not the case, the router will create the directory and all necessary device nodes on its own. This is to enable non-root users to pack a container. Dealing with /dev and its device nodes require root permissions. This should not be necessary for packing a container.

2 Can I develop containers on Windows?
--------------------------------------
Yes and no. Windows does not know things like symlinks. Thatfore a lot of the open source project will not cross compile. Packing a container also requires to be able to create symlinks.

3 Can I use the already existing /media/sf_M3_Container in my VM?
-----------------------------------------------------------------
Yes. VirtualBox will mount the directory automatically there, if the user configured the Shared Folder in the GUI. It is recommended to remove the empty directory `/home/user/src` and replace it with a symlink to the automatically created directory: `> rm /home/usr/src; ln -s /media/sf_M3_Container /home/user/M3_Container`.

4 Why fails compiling busybox with "read-only filesystem"?
----------------------------------------------------------
VirtualBox does not allow to follow symlinks as a security measure to avoid, that users leave the Shared Folder. You must allow following symlinks. Stop the SDK and use `> VBoxManage setextradata "VM_NAME" VBoxInternal2/SharedFoldersEnableSymlinksCreate/"SHARED" 1`

5 How should I begin with my own C/C++ application development?
---------------------------------------------------------------
Have a look at ./closed_source/hello_world. Use this as a template for your own application. Do not forget to enter your binary in the rootfs list (./scripts/rootfs_lists/default.txt), so your application will be included next time you pack a container.

6 The VM is slow/uncomfortable/etc, do I have to use this?
----------------------------------------------------------
No, absolutely not. The SDK should be a reference. It should be most robust, light weight and flexible. It is not the most performant or comfortable way to cross compile. Alternatives:  
- Use a native Gentoo Linux with its crossdev
- Extend the content of the SDK (X11, window mangager, editor) to a full desktop machine and develop completely within the VM
- Use any other ARMv7-hf toolchain (e.g. [http://www.acmesystems.it/arm0_toolchain](http://www.acmesystems.it/arm0_toolchain))
- use LXC on your linux PC: startup the SDK from a external boot medium, pack all content, extract it to your host and add a lxc.conf file. Automount your M3_Container directory and compile without the overhead of a real virtual machine.


# FAQ - Frequently Asked Questions

## Generic:
[What's the deal will all these names: M3, MRX, MRO?](#generic_1)<br>
[Can I develop containers on Windows or MAC OS?](#generic_2)<br>
[I imported a container on my device - how can I access it?](#generic_3)<br>
[Why can't I ping my new container?](#generic_4)<br>

## SDK:
[The VM is slow/uncomfortable/etc, do I have to use it?](#sdk_1)<br>
[Can I use the "shared folder" feature of VirtualBox?](#sdk_2)<br>
[Why can't I use my WLAN interface to bridge to the VM?](#sdk_3)<br>
[Why doesn't start the VM at all?](#sdk_4)<br>

## Programming:
[How can I start to compile everything that is available?](#programming_1)<br>
[How should I begin with my own C/C++ application development?](#programming_2)<br>
[Where do I get a build script for the open source project X version Y?](#programming_3)<br>
[Why is there no /dev in my container rootfs?](#programming_4)<br>

### <a name="generic_1">What's the deal will all these names: M3, MRX, MRO?</a>
M3 is the name of the product platform. MRX, MRO, LSX are products implemented on this platform. All containers can be installed and run on all devices build upon the M3 platform.

### <a name="generic_2">Can I develop containers on Windows or MAC OS?</a>
Yes, because the SDK is within a virtual machine.

There are other programming languages, which do not need a cross compiler like Python or already come with a cross compiler like Go (read [HowTo_Go_1_Intro.md](HowTo_Go_1_Intro.md)). Using one of these and use the routers capabilities to export containers and you will be fine.

### <a name="generic_3">I imported a container on my device - how can I access it?</a>
Most of the times a fresh container contains an SSH or telnet server. There will be a user with user name "root" and password "root". It is strongly recommended to change the root password with the command "passwd". It is also a good idea to add another user for further operations.

### <a name="generic_4">Why can't I ping my new container?</a>
Checklist:

- Have you assigned an IP address to the container, which is in your net?
- Have you assigned a MAC address to the container? In case you changed the MAC address recently, flush your ARP cache!
- Have you enabled the firewall? Then you need explicit rules to allow traffic to the container, too! Don't forget, that you need a FORWARD rule to allow traffic from the net interface to the virtual Ethernet interface of the container (e.g. FORWARD ALL from net2 to net2)
- In case the traffic must be routed before it gets to the container: Are all routes correctly set on all machines? Maybe you need to use NAT?

### <a name="sdk_1">The VM is slow/uncomfortable/etc, do I have to use it?</a>
No, absolutely not. The SDK should be a reference. It should be most robust, light weight and flexible. It isn't the most fast or comfortable way to cross compile. Alternatives:

- Use a native Gentoo Linux with its crossdev
- Extend the content of the SDK (X11, window mangager, editor) to a full desktop machine and develop completely within the VM
- use LXC on your Linux PC: read [Install_SDK_as_LXC_container.md](Install_SDK_as_LXC_container.md) to pack all content of the SDK and extract it to your host. Add a config file and mount your M3_Container or your whole home directory. Use the SDK without the overhead of a virtual machine.
- Use any other ARMv7-hf toolchain:
    - [https://buildroot.org](https://buildroot.org)
    - [http://crosstool-ng.org](http://crosstool-ng.org)
    - [http://www.acmesystems.it/arm0_toolchain](http://www.acmesystems.it/arm9_toolchain)
    - [https://www.yoctoproject.org](https://www.yoctoproject.org/)

### <a name="sdk_2">Can I use the "shared folder" feature of VirtualBox?</a>
Yes, it's possible to share files with the SDK this way.

Be aware that there are problems/limitations:

- The performance is very bad.
- Due to it's bad performance timing problems can occur, especially with parallel compiling.
- VirtualBox does not allow to follow symlinks as a security measure to avoid, that users leave the Shared Folder. You must allow following symlinks. Stop the SDK and use the command
<pre>
VBoxManage setextradata "VM_NAME" VBoxInternal2/SharedFoldersEnableSymlinksCreate/"SHARED" 1
</pre>

- Depending on the file system of the shared folder there can be problems with permissions, or the ownership (UID, GID) of the shared files. That might make it necessary to mount the shared folder manually in the SDK:<br>
"$ mount -t vboxsf -o uid=1000,gid=1000 folder_to_share /mnt/mount_point_in_SDK".

### <a name="sdk_3">Why can't I use my WLAN interface to bridge to the VM?</a>
A lot of WLAN chipsets do not support bridge mode. You will not get an error if you try to bridge a WLAN interface to the VM, but in most of the cases you will not get any traffic through to the VM. If you have to use WLAN (e.g. you have no Ethernet port) you will have to connect to the VM via NAT and use different IP networks on your host and within the VM.

### <a name="sdk_3">Why doesn't start the VM at all?</a>
Depending on your host system it can be necessary to modify the settings, especially "Settings -> Processor". More information can be found at the VirtuaBox vendor site: https://www.virtualbox.org/wiki/User_FAQ

### <a name="programming_1">How can I start to compile everything that is available?</a>
The /scripts/mk_all.sh is doing exactly that: It deletes all files that have been generated by former script executions, then it builds all open source project and finally creates all the available containers.

### <a name="programming_2">How should I begin with my own C/C++ application development?</a>
Have a look at ./closed_packages/hello_world. Use this as a template for your own application. Do not forget to enter your binary in the rootfs list (./scripts/rootfs_lists/default.txt), so your application will be included next time you pack a container.

### <a name="programming_3">Where do I get a build script for the open source project X version Y?</a>
Make one yourself and share it via GitHub! This applies also in case a build script exists, but there is a newer version of the project or you need modified compile options. Go to github, fork the repository, add or change build scripts and add a new pull request on github. Begin with the already existing template "./oss_packages/scripts/template.sh".

### <a name="programming_4">Why is there no /dev in my container rootfs?</a>
The router firmware will check if /dev exists within the rootfs of the container. If that is not the case, the router will create the directory and all necessary device nodes on its own. This is to enable non-root users to pack a container. Dealing with /dev and its device nodes require root permissions. This should not be necessary for packing a container.


<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>

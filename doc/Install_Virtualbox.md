Introduction
============
The SDK (Software Development Kit) is within a VirtualBox image. The SDK should be an independent reference building machine. It should not interfere with user configuration or the users preferred tools like editors.

The VM consists of a minimal Gentoo Linux installation without graphical user interface support. Installed is crossdev with the armv7-hf cross compiler tool chain.

The idea is: All code to be compiled should remain on the host PC and not within the SDK. To achive this a VirtualBox feature called "shared folder" can be used. The shared folder is most likley the cloned repository "M3_Container".

Install the SDK
===============
* Get and install [VirtualBox](https://virtualbox.org)
* Get the [SDK](https://www.insys-icom.de/data/smartbox/M3_SDK_2.ova)
* Start VirtualBox GUI and "Import Appliance", use the SDK image to import. IMPORTANT: Generate a new MAC address!
* Configure the VM:
    * Reserve at least 1 GByte RAM to the VM.
    * Let the VM use as many CPU cores as you can.
    * There is no need for GPU resources, there will be no GUI in the VM
    * Configure the net adapter. It is recommended to use a network bridge. That way you can ssh into the VM. Assign the  net interface of your PC that is used to connect your PC to the internet.
    It is not mandatory to configure networking to use the SDK, but it is useful for logins via SSH and to enable automatically downloads of the sources within the build scripts.
    * There is no immediate need to configure USB or serial interfaces.
    * Add a "shard folder": Select the directory of the cloned repository "M3_Container". Make sure that the checkbox "mount automatically" is checked and the the "read-only" checkbox is unchecked.
* To allow usage of symlinks within the shared folder the VM config has to be modified by the command:  
    `> VBoxManage setextradata "VM_NAME" VBoxInternal2/SharedFoldersEnableSymlinksCreate/"SHARED" 1`  
    with "VM_NAME" as the VM name (most likely "M3_SDK")  
    with "SHARED" the name of the shared folder (most liklely "M3_Container")  
    Without this modification the VM is not allowed to follow symlinks. This could be a problem when compiling some projects.

First steps within the SDK
==========================
* Start the virtual machine with the VirtualBox GUI to get the console login. There are two users:  
    "root", passwort is "root"  
    "user", password is "user"
* Test mounting the shared folder als normal "user":  
    `> mount -t vboxsf -o rw,uid=1000 M3_Container /home/user/src`
    This will mount the directory with the repository to the virtual machine directory /home/user/src
* If mounting has been successful (check with command "df") and you want to automatically mount the shared folder after every start of the VM, use this command as root:  
    `> su root`  
    `> echo "mount -t vboxsf -o rw,uid=1000 M3_Container /home/user/src" > /etc/local.d/mount_sf.start`  
    `> chmod 755 /etc/local.d/mount_sf.start`
* Configure networking as root  
    `> /root/set_ip.sh 192.168.1.3/24`  
    Change the IP address and net size to fit your net which is connected to the internet. The script will store the net configuration permanently. A SSH server will be configured and started, too.  
    Enter a default gateway:  
    `> nano /etc/conf.d/net`  
    Add a line similar to this: `routes_eth0="default gw 192.168.1.1"`  
    Edit the DNS servers  
    `> echo "nameserver 192.168.1.1" > /etc/resolv.conf`  

Usage of SDK
===================
Normally you will always log in as "user" via VirtualBox console or via SSH (ssh user@192.168.1.3) and use the build scripts of the mounted repository, so you will most likeley cd to /home/user/src and use the scripts there. Get more info about the directories and files there from the document "/home/user/src/doc/Directories_and_files.md". Examples:  

* Compile a single open source project, here: busybox  
`> cd /home/user/M3_Container`  
`> ./oss_packages/scripts/busybox all`  
If downloading the sources fails (no net connection, wrong default route, no DNS server) you will have to download the sources manually and store it in "oss_packages/dl".  

* Compile all content for a complete container, here: a small container with telnetd and init from busybox  
`> ./scripts/create_container_busybox.sh -n container_busybox`  




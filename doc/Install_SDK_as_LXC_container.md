Introduction
---

The SDK in form of a VirtualBox image is the most reliable and portable way to produce new containers. It still has a few disadvantages:

* The overall performance within a virtual machine (VM) is never that high than the one on the host machine. Compiling source code normally takes a lot of performance. Compiling within the VM can be very slow

* Exchanging files between the VM and the host system is not always that easy, it quite slow and takes a huge amount of CPU power. This pain can be eased but will never get extinct. Solutions might be mounting directories within the SDK by using scp, NFS, shared folders, FUSE, samba or even FTP. All of this solutions add a protocol with naturally slow down the file exchange. Every file exchange protocol will have additional problems, e.g. problems with synchronizing GIDs and UIDs, access rights or ownership of files. There is the problem of different file systems, where not all of them know symlinks or hardlinks. It may be forbidden to follow symlinks like it is the case with "shared folders".

* Living within a VM most of the times is quite uncomfortable. There never are the right tools like editors. In case of the SDK there is not even an X server installed.

The solution is LXC 
---
The same mechanism used within the M3 platform devices can be used on every modern Linux machine. Let the SDK run in an LXC container. Share all files except the SDK system files with your host system and use the SDK (toolchain) for compiling sources and packaging the containers.

Using the SDK as an LXC container will result in a huge performance improvement when compiling. The pain with the file exchange will go away and starting up the SDK will happen almost instantly.

1. Extract the content of the SDK into a directory
2. Make minor modifications to some files of the SDK
3. Create a configuration file for LXC
4. Start the LXC Container on your host system

LXC must be installed on your host system. The kernel of the host system must support CGroups and namespaces, witch is most likely already included. Read more on the [LXC website](https://linuxcontainers.org/lxc/getting-started)

Extract the SDK
---
Start the virtual machine with the SDK and log in as root. Change to the / directory and pack the content of the SDK. Do not pack directories with runtime data like "tmp", "sys" or "proc"!
	<pre>
	m3sdk login: root
	Password: root
	m3sdk ~ # cd /
	m3sdk / # tar zcf rootfs.tar.gz bin etc home lib media mnt opt root sbin usr var
	</pre>

On the host system (not within the SDK) prepare the place for the root file system of the new LXC container. Depending on your linux distribution the place to install LXC container may be different. It's assumed, all containers are located in "/etc/lxc":
	<pre>
	root@host # mkdir -p /etc/lxc/m3sdk/rootfs
	</pre>
	
Transfer the packed content of the SDK to the new directory of the host system and extract it:
    <pre>
	root@host # scp root@IP-address-of-SDK:/rootfs.tar.gz /etc/lxc/m3sdk/rootfs	
    root@host # cd /etc/lxc/m3sdk/rootfs
    root@host rootfs # tar xf rootfs.tar.gz
    </pre>
    
Create the missing directory that will contain temporary data and have not been packed from the SDK:    
    <pre>  
    root@host rootfs # mkdir dev proc run sys tmp
    </pre>
    

Make minor modifications to some files of the SDK
---
There are minor changes to be made in the rootfs of the LXC container.

To automatically log in as "user" when the LXC container gets started enter this as the first line in "/etc/inittab":
    <pre>
    root@host # cd /etc/lxc/m3sdk/rootfs
    root@host rootfs # nano /etc/lxc/m3sdk/rootfs/etc/inittab
    1:12345:respawn:/sbin/agetty -a user --noclear 115200 console linux
    </pre>
    
Get the user and group ID (UID, GID) of the user in the LXC container to the same values of the user, with which you normally log into your host system. Here it's assumed the user has UID 1001 and GID 1005:
    <pre>
    root@host rootfs # id \<your_user_name\> -u
    1001
    root@host rootfs # id \<your_user_name\> -g
    1005
    </pre>
    
Modify the UID and GID of the user "user" of the LXC container:
    <pre>
    root@host rootfs # nano /etc/lxc/m3sdk/rootfs/etc/passwd
    ...    
    user:x:1001:1005::/home/user:/bin/bash
    ...
    </pre>
    
Stop the start of networking, as there is no different netspace. Stop starting the VirtualBox Guest additions and sshd. This only avoids error messages when starting the LXC container:
    <pre>
    root@host rootfs # rm /etc/lxc/m3sdk/rootfs/etc/runlevels/default/*
    root@host rootfs # rm /etc/lxc/m3sdk/rootfs/etc/runlevels/boot/net.lo
    </pre>
   
    
Create a configuration file for LXC
---
To start an LXC container a config file is needed. It is located in "/etc/lxc/m3sdk/"
    <pre>
    root@host rootfs # nano /etc/lxc/m3sdk/config
    </pre>
    
Fill the configuration with this lines:
    <pre>
    lxc.network.type = none
    lxc.rootfs = /etc/lxc/m3sdk/rootfs
    lxc.haltsignal = SIGUSR1
    lxc.utsname = m3sdk
    lxc.tty = 10
    lxc.pts = 1024
    lxc.cap.drop = audit_control audit_write dac_read_search fsetid ipc_owner linux_immutable mac_admin mac_override mknod setfcap sys_admin sys_boot sys_module sys_pacct sys_ptrace sys_rawio sys_resource sys_time sys_tty_config syslog
    lxc.mount.entry = /dev dev none rw,bind 0 0
    lxc.mount.entry = proc proc proc nodev,noexec,nosuid 0 0
    lxc.mount.entry = sysfs sys sysfs ro 0 0
    </pre>
    
Mount the M3_Container directory  or optionally the complete home directory of your normal user of the host system automatically into the LXC container. Append this line to the config file above and modify the real user name of your host system:
    <pre>
    lxc.mount.entry = /home/<your_user_name> home/user defaults rw,bind 0 0
    </pre>
    
You can mount as much directories as you wish, as long the mount points in the LXC container exist and the user has the permission to enter them.

Start the LXC Container on your PC
---
Starting and stopping a container may require root permissions on the host system. 
    <pre>
    $ su root
    Passwort: 
    root@host ~ # lxc-start -n m3sdk
    </pre>

Optionally open another console in the SDK:
    <pre>
    root@host ~ # lxc-console -n m3sdk
    </pre>

The container will start immediately in the terminal, where the command has been entered. The prompt changes to "user@m3sdk ~ $". Stopping a container must be done from another terminal:
    <pre>
    $ su root
    Passwort: 
    root@host ~ # lxc-stop -n m3sdk -k
    </pre>

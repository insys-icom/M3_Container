Introduction
---
The SDK (Software Development Kit) is a VirtualBox image. The SDK should be an independent reference building machine. It should not interfere with the users host system.

The VM consists of a minimal Gentoo Linux installation without graphical user interface support. Installed is crossdev with the armv7-hf cross compiler toolchain.

The SDK is supposed to have access to the internet in order to be able to clone this repository and to get the open-source-packages needed to fill the containers. Therefore one Ethernet interface must be bridged to the SDK.

To exchange files from the host with the SDK a VirtualBox feature called "shared folder" can be used, but be warned:

* Caveat 1: The performance of the "shared folder" feature might be very slow, especially when compiling projects with a huge amount of files.
* Caveat 2: Compiling projects that rely on symlinks (e.g. "busybox") will fail, when the host operating system doesn't support symlinks (like "Windows" lacks). In this case the project files must be compiled within the SDK without the use of this "shared folder" feature.

The SDK has been kept as small as possible, but naturally it can be adjusted by simply adding new packets like X and a window manager (for a GUI), editors, additional compilers (e.g. LaTeX, haskell, go-lang) or other applications by using the Gentoo package manager [portage](https://wiki.gentoo.org/wiki/Handbook:AMD64/Full/Portage).


Install the SDK
---
* Get and install [VirtualBox](https://virtualbox.org)
* Get the [SDK](https://m3-container.net/M3_Container/SDK/M3_SDK.ova)
* Start VirtualBox GUI and "Import Appliance", use the SDK image to import. IMPORTANT: Generate a new MAC address!
* Configure the VM:
    * Reserve at least 1 GByte RAM to the VM.
    * Let the VM use as many CPU cores as you can.
    * There is no need for GPU resources, there will be no GUI in the VM
    * Configure the net adapter. It is recommended to use a network bridge. That way the VM gets internet access and you can ssh into the VM from your host. Assign the  net interface of your PC that is used to connect your PC to the internet. It's not mandatory to configure networking to use the SDK, but it is useful for logins via SSH and to enable automatically downloads of the sources within the build scripts.
    * There is no immediate need to configure USB or serial interfaces.


First steps within the SDK
---
* Start the virtual machine with the VirtualBox GUI to get the console login. There are two users:
    * "root", password is "root"
    * "user", password is "user"
* Log in as user and become root for configuring purpose:
    <pre>
        m3sdk login: user
        Password: user
    	user@m3sdk ~ $ su root
    	Password: root
    </pre>
* Configure networking. It's assumed you bridged an Ethernet interface to the SDK, your LAN is the 192.168.2.0/24 and your gateway has the IP address 192.168.2.1/24.
    Configure a free IP address of your LAN to the Ethernet interface within the SDK:
    <pre>
        m3sdk user # /root/set_ip.sh 192.168.2.3/24
    </pre>
    Configure the default gateway:
    <pre>
        m3sdk user # echo 'routes_enp0s3="default gw 192.168.2.1"' >> /etc/conf.d/net
    </pre>
    Configure a DNS server address:
    <pre>
        m3sdk user # echo "nameserver 192.168.2.1" > /etc/resolv.conf
    </pre>
    Restart the net configuration
    <pre>
        m3sdk user # /etc/init.d/net.enp0s3 restart
    </pre>
    Test the internet connection
    <pre>
        m3sdk user # ping -c 4 insys-icom.de
    </pre>

* Exit the VM as root and continue to work as "user" from now on. Clone this repository into the SDK:
    <pre>
        m3sdk user # exit
    </pre>
* Clone this repository into the SDK. In case you already have an account at github you can alternatively use the ssh protocol:
    <pre>
        user@m3sdk ~ $ git clone git@github.com:insys-icom/M3_Container.git
    </pre>
    With no account you have to use HTTPS:
    <pre>
        user@m3sdk ~ $ git clone https://github.com/insys-icom/M3_Container.git
    </pre>

    The directory "M3_Container" will be created and filled with the content of the repository.


Usage of SDK
---
Normally you will always log in as "user" via VirtualBox. It's recommended to use SSH to login to the SDK (ssh user@192.168.2.3) instead of the console that VirtualBox gives you after starting the SDK. In case your host system doesn't have an built in SSH client you might try [Putty](http://www.chiark.greenend.org.uk/~sgtatham/putty/ "Putty").

Normally you will use the scripts that came with the repository. Enter the directory:
    <pre>
    user@m3sdk ~ $ cd M3_Container
    </pre>
    Read more about the directories and files of this repository in [doc/Directories_and_files.md]("doc/Directories_and_files.md").

* Compile a single open source project, here: mcip
    <pre>
    user@m3sdk ~/M3_Container $ ./oss_packages/scripts/mcip.sh all
    </pre>
If downloading the sources fails (no internet connection, wrong default route, no DNS server) you will have to download the sources manually and store them in "oss_packages/dl".

* Compile the complete content for a container: a small container with telnetd and init from busybox
    <pre>
    user@m3sdk ~/M3Container $ ./scripts/create_container_busybox.sh -n container_busybox
    </pre>


Using shared folders with SDK
---
In order to exchange file between SDK and host system more comfortably VirtualBox comes with a feature called "Shared folders". Via VirtualBox GUI you can define one ore more directories, that can be mounted by the SDK. The files within the directory will stay on your host system. They can be read and modified within the SDK.

This is useful to get easy access to the update packages with the final container. It's also very comfortable to edit the sources of your own applications with the graphical editor you are used to and share these files with the SDK, which can use them to compile and package them.

Caveat 1: The "shared folder" feature doesn't perform very well. Compiling projects with a huge amount of files can be very slow.

Caveat 2: Using "shared folders" might not be able to compile projects that relay on Linux symlinks (like "busybox"), when the host operating system (like "Windows") doesn't support symlinks. In that case the only way is to compile the project completely within the virtual machine. That means that the project files to be compiled must be transfered into a directory of the SDK (via scp, ftp or http).

To add a "shard folder":

* Create a new directory on your host, that should be shared with the SDK.

* Use the VirtualBox GUI and select "Shared Folder". Add the shared folder by using the symbol. Select the directory to be shared. Enter the directory name. It's assumed for this example that it's named "images". Do _not_ tick the checkbox "mount automatically" or the "read-only" checkbox.

* Start up the virtual machine "M3SDK".

* SSH into the SDK as "user" and empty the directory, into which the shared folder should be mounted. For this example the directory "~/M3_Container/images" should be shared, so the final containers are easily available for the host.
    <pre>
    $ ssh user@192.168.2.3
    Password: user
    m3sdk@user ~ $ rm -Rf ./M3_Container/images/*
    </pre>

* Become "root"
    <pre>
    user@m3sdk ~ $ su root
    Password: root
    </pre>

* Create the script that will mount the shared folder with read/write permissions and the correct UID/GID whenever the SDK starts.
    <pre>
    m3sdk user $ nano /etc/local.d/vboxsf_mount.start
    </pre>

* Enter these lines into the script:
    <pre>
    #!/bin/sh
    mount -t vboxsf -o rw,uid=1000 images /home/user/M3_Container/images
    </pre>

* Give the script the correct permisssions and add it to the system start, so the mounting happens every time the SDK starts:
    <pre>
    m3sdk user $ chmod 755 /etc/local.d/vboxsf_mount.start
    m3sdk user $ /etc/local.d/vboxsf_mount.start
    m3sdk user $ rc-update add local default
    </pre>

Add more shared folders as you like, e.g. directories in ~/M3_Container/closed_source, that will contain your own applications. Within the SDK every new shared folder must be configured in "/etc/local.d/vboxsf_mount.start".

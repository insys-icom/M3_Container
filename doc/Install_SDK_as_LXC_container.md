Introduction
---
This guide will describe how to install the SDK as an LXC container on a Linux machine.

Why not using the SDK as a VirtualBox image?
---
The SDK in form of a VirtualBox image is the most reliable and portable way to produce new containers. Unfortunately it has a few disadvantages:

* The overall performance within a virtual machine (VM) is never that high than the one on the host machine.
* Exchanging files between the VM and the host system can be a quite a hassle.
* Working within a VM can be quite uncomfortable (lack of GUI, familiar editor, tools..).

The solution is LXC
---
The same mechanism used within the M3 platform devices can be used on every modern Linux machine.
Let the SDK run in an LXC container.
Share all files in your users home directory of the host with the LXC container.
That way you can edit the source files with your hosts editors and tools and use the SDK from within the LXC container to compile them.

Using the SDK as an LXC container will result in a huge performance improvement when compiling compared to a SDK as a virtual machine. The pain with the file exchange will go away and starting up the SDK will happen almost instantly.

Preconditions:

* You must run Linux on your host system.
* LXC must be installed.
* The kernel of the host system must support CGroups and namespaces, which is most likely already included.

Read more on the [LXC website](https://linuxcontainers.org/lxc/getting-started)

Installation
---
1. Download the [SDK as LXC container](https://m3-container.net/M3_Container/SDK/M3_SDK_LXC.tar.gz)

2. Become root and extract the archive. It's assumed that the all LXC containers are installed in /var/lib/lxc
    <pre>
    user@host ~ # <b>su root</b>
    Password:
    root@host ~ # <b>tar xf *PATH_OF_THE_DOWNLOADES_SDK_ARCHIVE* -C /var/lib/lxc</b>
    </pre>

3. Find out the normal users UID and GID. It's assumed that they are 1001 and 1005:
    <pre>
    root@host ~ # <b>id *YOUR_USER_NAME* -u</b>
    1001
    root@host ~ # <b>id *YOUR_USER_NAME* -g</b>
    1005
    </pre>

4. Modify the UID and GID of the user "user" of the LXC container:
    <pre>
    root@host ~ # <b>nano /var/lib/lxc/m3sdk/rootfs/etc/passwd</b>
    ...
    user:x:<b>1001</b>:<b>1005</b>::/home/user:/bin/bash
    ...
    </pre>

5. Mount the normal users home directory of the host into the LXC container. After starting the LXC container all files of the normal user on the host are the same in the container. To do that modify the configuration file of the LXC container:
    <pre>
    root@host ~ # <b>nano /var/lib/lxc/m3sdk/config</b>
    </pre>
Replace the the line with user <b>moros</b> with the real user name of your host system:
    <pre>
    lxc.mount.entry = /home/<b>*YOUR_USER_NAME*</b> home/user defaults rw,bind 0 0
    </pre>
Mount as much directories as you wish, as long the mount points in the LXC container exist.

Start the LXC container
---
Starting and stopping a container may require root permissions on the host system.
<pre>
user@host ~ # <b>su root</b>
Password:
root@host ~ # <b>lxc-start -P /var/lib/lxc -n m3sdk</b>
</pre>

Open a console to the LXC container:
<pre>
root@host ~ # <b>lxc-console -P /var/lib/lxc -n m3sdk</b>
</pre>

Login as <b>"user"</b> with the password <b>"user"</b>. The password for the user "root" is "root". The prompt changes to "user@m3sdk ~ $". Stopping a container must be done from another terminal:
<pre>
user@host ~ # <b>su root</b>
Password:
root@host ~ # <b>lxc-stop -P /var/lib/lxc -n m3sdk -k</b>
</pre>

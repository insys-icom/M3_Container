Introduction
---
This guide will describe how to install the SDK as an LXC container on a Linux machine.


The solution is LXC
---
Let the SDK run in an LXC container on your Linux host PC.
Share all files in your users home directory of the host with the LXC container.
That way you can edit the source files with your hosts editors and tools and use the SDK from within the LXC container to compile them.

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

3. Find out the your users UID and GID. For most installations they are 1000 and 1000. If that is the case, you can skip this.
    <pre>
    root@host ~ # <b>id *YOUR_USER_NAME* -u</b>
    1001
    root@host ~ # <b>id *YOUR_USER_NAME* -g</b>
    1005
    </pre>

    Modify the UID and GID of the user "user" of the LXC container, so it is the same as the users UID and GID of your host computers user. In this example UID is 1001 and GID is 1005:
    <pre>
    root@host ~ # <b>nano /var/lib/lxc/m3sdk/rootfs/etc/passwd</b>
    ...
    user:x:<b>1001</b>:<b>1005</b>::/home/user:/bin/bash
    ...
    </pre>

4. Mount the normal users home directory of the host into the LXC container. After starting the LXC container all files of the normal user on the host are the same in the container. To do that modify the configuration file of the LXC container:
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
Starting and stopping a container may require root permissions on the host system. This will start the container and immediatelly auto log in as "user". Most of the time you only need a single terminal within the SDK.
<pre>
user@host ~ # <b>su root</b>
Password:
root@host ~ # <b>lxc-start m3sdk -F</b>
</pre>

If you really need another console to the LXC container:
<pre>
root@host ~ # <b>lxc-console m3sdk</b>
</pre>

Login as <b>"user"</b> with the password <b>"user"</b>. The password for the user "root" is "root". The prompt changes to "user@m3sdk ~ $". Stopping a container must be done from another terminal:
<pre>
user@host ~ # <b>su root</b>
Password:
root@host ~ # <b>lxc-stop m3sdk</b>
</pre>

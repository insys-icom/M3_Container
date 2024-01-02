Run the SDK as an LXC container
---
Running the SDK as an container on you PC avoids polluting your hosts file system.
Share all files in your users home directory of the host with the LXC container by mounting, to avoid the need to copy files to and from the container.
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

3. Find out the UID and GID of the user on your host machine, with that you login normally. For most installations they are both 1000. If that is the case, you can skip this.
    <pre>
    root@host ~ # <b>id *YOUR_USER_NAME* -u</b>
    1001
    root@host ~ # <b>id *YOUR_USER_NAME* -g</b>
    1005
    </pre>

    Modify the UID and GID of the user "user" of the LXC container, so they the same as the users UID and GID of your host computers user. In this example UID is 1001 and GID is 1005:
    <pre>
    root@host ~ # <b>nano /var/lib/lxc/m3sdk/rootfs/etc/passwd</b>
    ...
    user:x:<b>1001</b>:<b>1005</b>::/home/user:/bin/bash
    ...
    </pre>

4. Mount directories into the container. After starting your container, you will see these mounted directories, as you do on your host computer. That way you can work on the same files from within the container and on your host PC. This avoids the need to copy files into and from the LXC container:
    <pre>
    root@host ~ # <b>nano /var/lib/lxc/m3sdk/config</b>
    </pre>

    Replace the the line with user <b>YOUR_USER_NAME</b> with the real user name of your host system, to replace the home directory in the SDK with your users home directory:
    <pre>
    lxc.mount.entry = /home/<b>*YOUR_USER_NAME*</b> home/user defaults rw,bind 0 0
    </pre>
    Repeat this for other directories. In case you don't want to mount the home dir of the user, but only specific directories, you have to be sure, that the mount point already exists in the LXC container, e.g. /var/lib/lxc/m3sdk/rootfs/home/user/M3_Container.

Start the LXC container
---
Starting and stopping a container may require root permissions on the host system. This will start the container and immediatelly auto log in as "user". Most of the time you only need a single terminal within the SDK, so you could start the container in foreground:
<pre>
user@host ~ # <b>su root</b>
Password:
root@host ~ # <b>lxc-start m3sdk -F</b>
</pre>

If you really need another console to the LXC container:
<pre>
root@host ~ # <b>lxc-console m3sdk</b>
</pre>
Login as <b>"user"</b> with the password <b>"user"</b>. The password for the user "root" is "root". The prompt changes to "user@m3sdk ~ $".

Stopping a container from another terminal:
<pre>
user@host ~ # <b>su root</b>
Password:
root@host ~ # <b>lxc-stop m3sdk</b>
</pre>

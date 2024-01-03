Run the SDK as a Docker container
---
Running the SDK as an container on your Linux PC avoids polluting your hosts file system.
Share all files in your users home directory of the host with the LXC container by mounting.
That way you can edit the source files with your favourite editor and tools on your PC and use the SDK from within the LXC container to (cross-) compile them.

Preconditions:
* You must run Linux on your host system.
* Docker must be installed.

Create the Docker image
---
1. Download the [SDK as LXC container](https://m3-container.net/M3_Container/SDK/M3_SDK_LXC.tar.gz)

2. Become root, extract the archive and enter the new directory with the extracted SDK.
    <pre>
    user@host ~ # <b>su root</b>
    Password:
    root@host /home/joe # <b>tar xf *PATH_OF_THE_DOWNLOADED_SDK_ARCHIVE*</b>
    root@host /home/joe # <b>cd m3sdk_6</b>
    root@host /home/joe/m3sdk_6 #
    </pre>

3. Find out the UID and GID of the user on your host machine. Let's assume the user name is "joe". For most installations they are both 1000. In that case, you can skip this.
    <pre>
    root@/home/joe/m3sdk_6 ~ # <b>id joe -u</b>
    1001
    root@/home/joe/m3sdk_6 ~ # <b>id joe -g</b>
    1005
    </pre>

    Modify the UID and GID of the user "user" of the SDK, so they the same as the users UID and GID of your host computers user. In this example UID is 1001 and GID is 1005:
    <pre>
    root@/home/joe/m3sdk # <b>nano rootfs/etc/passwd</b>
    ...
    user:x:<b>1001</b>:<b>1005</b>::/home/user:/bin/bash
    ...
    </pre>

4. Create a Dockerfile: Paste this into a file called "Dockerfile" in the current directory
    <pre>
    FROM scratch
    ADD rootfs/ /
    CMD ["/sbin/init"]
    </pre>

5. Create the docker image:
    <pre>
    root@/home/joe/m3sdk # <b>docker build -t m3sdk .</b>
    </pre>

Start the Docker container
---
From now on you can start Docker containers. Optionally mount directories as volumes into the container. After starting your container, you will see these mounted directories, as you do on your host computer. That way you can work on the same files from within the container and on your host PC. This avoids the need to copy files into and from the LXC container.

As an example mount the whole home directory of the user "joe" into the container, so immediatelly can start using the SDK with already existing code:
    <pre>
    root@host # <b>docker run --rm -it --volume "/home/joe/:/home/user/" m3sdk /sbin/init</b>
    </pre>

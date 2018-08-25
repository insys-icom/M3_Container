# Container Application "Etherpad Lite"

## Introduction
Etherpad is "a highly customizable Open Source online editor providing collaborative editing in really real-time" ([cited from http://etherpad.org](http://etherpad.org)). It's an application written for NodeJS. This editor runs within a browser and allows concurrent editing in real time by several users.

This document will describe how to install Ethernet within a container.

## Install and configure a container with NodeJS
Make sure the time and date of the router is up to date. This is important for certificates to become valid.

Upload and configure the [NodeJS container](https://m3-container.net/M3_Container/images/container_nodejs.tar) on your router. Bridge the container to an IP net that has access to the internet and set the gateway IP address. If the DNS server IP address is not the same as the IP address of the gateway, enter the container and set it:
<pre>
user@ps ~  $ <b>ssh root@192.168.1.1</b>
root@container_nodejs ~  $ <b>echo "nameserver *IP_ADDRESS_OF_NAMESERVER*" > /etc/resolv.conf</b>
</pre>

Test the internet connection:
<pre>
root@container_nodejs ~  $ <b>ping etherpad.org</b>
</pre>

## Install Etherpad
Update the packet manager tool npm:
<pre>
root@container_nodejs ~  $ <b>npm i -g npm</b>
</pre>

Get the latest Etherpad files into your container:
<pre>
root@container_nodejs ~  $ <b>wget https://github.com/ether/etherpad-lite/zipball/master</b>
</pre>

Unpack the archive:
<pre>
root@container_nodejs ~  $ <b>unzip master</b>
</pre>

## Start Etherpad
Etherpad will always look for updates and missing files before starting. The first launch will last for several minutes. Enter the new directory, which name is dependent on the time you downloaded the archive.
<pre>
root@container_nodejs ~  $ <b>ls</b>
ether-etherpad-lite-9f51432
root@container_nodejs ~ $ <b>./ether-etherpad-lite-9f51432/bin/run.sh --root</b>
</pre>

Wait until the installer has finished with a message like:
<pre>
[2017-05-10 11:10:19.406] [INFO] console - You can access your Etherpad instance at http://0.0.0.0:9001/
</pre>

Open a browser and enter the the IP address of the container and the port. Example:
<pre>
http://192.168.1.2:9001
</pre>

This will also take a few seconds. Enter the name of a new pad and start to enjoy Etherpad!

## Start Etherpad automatically
In case you want to start Etherpad automatically after the container start enter this as a service in /etc/finit.conf

<pre>
root@container_nodejs ~  $ <b>vi /etc/finit.conf</b>
</pre>

Again enter the editing mode of vi with "i" and append this line:
<pre>
service /root/ether-etherpad-lite-9f51432/bin/run.sh --root
</pre>

Store and exit vi with the keys *ESC : x*.

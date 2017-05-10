# Container Application "Etherpad Lite"

## Introduction
Etherpad is "a highly customizable Open Source online editor providing collaborative editing in really real-time" ([cited from http://etherpad.org](http://etherpad.org)). Is an application written for NodeJS. This editor runs within a browser and allows concurrent editing in real time by several users.  

This document will describe how to install Ethernet within a container.

## Install and configure a container with NodeJS
Upload and configure the [NodeJS container](https://m3-container.net/M3_Container/images/container_nodejs.tar) on your router. Bridge the container to an IP net that has access to the internet. Enter the container and setup networking there. Enter a reachable address for the DNS server, most liklely this will be the routers IP address:
<pre>
root@container-nodejs ~  $ <b>echo "nameserver \<IP address of nameserver\>" > /etc/resolv.conf</b>
</pre>

Edit the script that will set the default gateway after starting the container:
<pre>
root@container-nodejs ~  $ <b>vi /bin/start_net</b>
</pre>
Press \<i\> to enter the editing mode of vi and exchange the IP address of the default gateway, most likely this will also be the routers IP address. Store and exit vi with the keys \<ESC\>\<:\>\<x\>.

Execute the script, so the default route gets set:
<pre>
root@container-nodejs ~  $ <b>/bin/start_net</b>
</pre>

Test the internet connection:
<pre>
root@container-nodejs ~  $ <b>ping etherpad.org</b>
</pre>

## Install Etherpad
Get the latest Etherpad files into your container:
<pre>
root@container-nodejs ~  $ <b>wget https://github.com/ether/etherpad-lite/zipball/master</b>
</pre>

Unpack the archive:
<pre>
root@container-nodejs ~  $ <b>unzip master</b>
</pre>

## Start Etherpad
Etherpad will always look for updates and missing files before starting. The first launch will last for several minutes. Enter the new directory, which name is dependent on the time you downloaded the archive.
<pre>
root@container-nodejs ~  $ <b>ls</b>
ether-etherpad-lite-9f51432
root@container-nodejs ~ $ <b>./ether-etherpad-lite-9f51432/bin/run.sh --root</b>
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
root@container-nodejs ~  $ <b>vi /etc/finit.conf</b>
</pre>

Again enter the editing mode of vi with \<i\> and append this line:
<pre>
service /root/ether-etherpad-lite-9f51432/bin/run.sh --root
</pre>

Store and exit vi with the keys \<ESC\>\<:\>\<x\>.

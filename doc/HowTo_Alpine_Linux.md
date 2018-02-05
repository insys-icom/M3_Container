# Container "Alpine Linux"

## Introduction
[Alpine Linux](https://www.alpinelinux.org) is a very small Linux distribution based on musl libc and busybox. This container is thought for users, that want to build containers with very small footprint without compiling and building on their own. This solution is in between a full blown Debian container and a container built from scratch.

This document will describe how to install Alpine Linux within a container and will show some of the first steps in it.

## Install and configure the container
Download the [Alpine Linux container](https://m3-container.net/M3_Container/images_static/Alpine_3.7.tar) and store it on your PC.

- Open a browser and enter the IP address <b>"192.168.1.1"</b> of web interface of the [M3 device in default settings](http://192.168.1.1/cgi_s_administration.container).
- Click in menu <b>"Administration"</b> on the button <b>"import container"</b> to upload the stored container to the M3 device. The new container will appear in the list.
- Click <img src="assets/icons/magic_wand.png" alt="the wand icon" width="15"> to create a configuration for this container.
- Click <img src="assets/icons/pen.png" alt="the pen icon" width="15"> to enter the configuration for the container.
- Select the <b>"IP net1"</b> to which the containers Ethernet interface should be bridged
- Enter a free IPv4 address, e.g. <b>192.168.1.3</b> and its net mask <b>24</b>
- Click to <b>"Save settings"</b>
- Click the blinking <img src="assets/icons/gear.png" alt="the gear icon" width="15"> to activate the profile

This will start a Alpine Linux in the new container.

## Login to the container and configure networking
Alpine Linux will start an SSH server that can be used to login. Open a terminal or a putty and enter the configured IP address of the container:
<pre>
joe@pc ~  $ <b>ssh root@192.168.1.3</b>
</pre>

When using putty enter the IP address and click connect. The user name is <b>"root"</b>, the password is also <b>"root"</b>.

The first thing to do is to <b>change the password</b> of the user "root"! This container will behave like a real PC that nasty people want to enter and install their bot net client on it to use it for their nasty goals:
<pre>
container1:~# <b>passwd</b>
</pre>

Configure networking now. The IP address has already been set by the configuration of the M3 device. What still is missing is the default gateway Use the tiny editor "vi" to edit the file:
<pre>
container1:~# <b>vi /etc/local.d/routes.start</b>
</pre>

The editor vi has two modes:

- command mode: save or to exit the edited file. Press <b>"i"</b> ("insert") to change to edit mode.
- edit mode: actually change text. Press <b>\<ESC></b> to leave edit mode.

In this document the M3 device itself should act as the gateway, which is already configured. In this case there is nothing to do here. Otherwise press "i" to enter "edit mode" and change the IP address to the one of the correct gateway. Leave edit mode to store and exit the editor with the keys <b>\<ESC>:x</b> (first \<ESC> to return to command mode, then the ":" to introduce a command, finally "x" as the command to store and exit vi).

When the IP address of the gateway has changed, the new default route can be set:
<pre>
container1:~# <b>/etc/init.d/local restart</b>
</pre>

To be able to resolve domain names the IP address of the DNS server must be set:
<pre>
container1:~# <b>vi /etc/resolv.conf</b>
</pre>

The M3 device will most likely always act as the gateway to the internet. If this has not been configured yet (WAN chains, IP routes, IP netfilters like NAT), it should be done now. Please consult the documentation of the M3 devices. Test if the container can reach its targets you can use the tool <b>"ping"</b> in the container:

<pre>
container1:~# <b>ping insys-icom.com</b>
</pre>

## Install additional programs
Alpine Linux comes with a packet management tool called <b>"apk"</b>. It should be updated:
<pre>
container1:~# <b>apk update</b>
</pre>

After that packages from a huge [pool](https://pkgs.alpinelinux.org/packages) can be installed, for instance the web server "lighttpd":
<pre>
container1:~# <b>apk add lighttpd</b>
</pre>

Start the service:
<pre>
container1:~# <b>rc-service lighttpd start</b>
</pre>

Start the service automatically after the container starts:
<pre>
container1:~# <b>rc-update add lighttpd default</b>
</pre>

Create a small web page the web server can deliver:
<pre>
container1:~# <b>vi /var/www/localhost/htdocs/index.html</b>
</pre>

Create a little web site like this:
```
<html>
	<body>Hello world!</body>
</html>
```

This site should now be accessible with a web browser: [http://192.168.1.3](http://192.168.1.3)

The [website](https://wiki.alpinelinux.org/wiki/Main_Page) of Alpine Linux offers a lot of additional useful documentation like [Tutorials](https://wiki.alpinelinux.org/wiki/Tutorials_and_Howtos) or [FAQs](https://wiki.alpinelinux.org/wiki/Alpine_Linux:FAQ)

# FAQ - Frequently Asked Questions

## Generic:
[What's the deal will all these names: M3, MRX, MRO?](#generic_1)<br>
[Can I develop containers on Windows or MAC OS?](#generic_2)<br>
[I imported a container on my device - how can I access it?](#generic_3)<br>
[Why can't I ping my new container?](#generic_4)<br>

## Programming:
[How should I begin with my own C/C++ application development?](#programming_1)<br>
[Where do I get a build script for the open source project X version Y?](#programming_2)<br>
[How could]

### <a name="generic_1">What's the deal will all these names: M3, MRX, MRO?</a>
M3 is the name of the product platform. MRX, MRO, LSX are products implemented on this platform. All containers can be installed and run on all devices build upon the M3 platform.

### <a name="generic_2">Can I develop containers on Windows or MAC OS?</a>
No, not any longer, as we don't provide the SDK as a virtual machine any longer. You can extract the LXC container of the SDK and create a VM for yourself. You would have to start from another medium, chroot into the rootfs of the SDK and install a bootloader and a kernel.

There are other programming languages, which do not need a cross compiler like Python or already come with a cross compiler like Go (read [HowTo_Go_1_Intro.md](HowTo_Go_1_Intro.md)). Using one of these and use the routers capabilities to export containers and you will be fine.

### <a name="generic_3">I imported a container on my device - how can I access it?</a>
Most of the times a fresh container contains an SSH or telnet server. There will be a user with user name "root" and password "root". It is strongly recommended to change the root password with the command "passwd". It is also a good idea to add another user for further operations.

### <a name="generic_4">Why can't I ping my new container?</a>
Checklist:

- Have you assigned an IP address to the container, which is in your net?
- Have you assigned a MAC address to the container? In case you changed the MAC address recently, flush your ARP cache!
- Have you enabled the firewall? Then you need explicit rules to allow traffic to the container, too! Don't forget, that you need a FORWARD rule to allow traffic from the net interface to the virtual Ethernet interface of the container (e.g. FORWARD ALL from net2 to net2)
- In case the traffic must be routed before it gets to the container: Are all routes correctly set on all machines? Maybe you need to use NAT?

### <a name="programming_1">How should I begin with my own C/C++ application development?</a>
Have a look at ./closed_packages/hello_world. Use this as a template for your own application. Do not forget to enter your binary in the rootfs list (./scripts/rootfs_lists/default.txt), so your application will be included next time you pack a container.

### <a name="programming_2">Where do I get a build script for the open source project X version Y?</a>
Make one yourself and share it via GitHub! This applies also in case a build script exists, but there is a newer version of the project or you need modified compile options. Begin with the already existing template "./oss_packages/scripts/template.sh".


<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>

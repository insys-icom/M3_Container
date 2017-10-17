# Container Application Development with Java

## Quick Start Guide

### Introduction
Java is a famous programming language. Compiled Java code can run on any platform with a Java Virtual Machine, so it's highly portable. This HowTo describes the steps to get a Container with a Java Virtual Machine in it.

To be able to start Java applications there must be a Java Virtual Machine and a set of class libraries. In this HowTo the Oracle Java SE will be used. Due to the "Oracle Binary Code License Agreement" it's not allowed to offer an already prepared container image. Creating a container with Oracle Java is quite easy:

- Get a working container on the M3 device:
	- Either create a default container on the device
	- or install an already prepared ([default](https://m3-container.net/M3_Container/images/container_default.tar)) container from [https://m3-container.net](https://m3-container.net/M3_Container/images)
- [Download](http://www.oracle.com/technetwork/java/javase/downloads) Java SE JDK
- Copy the needed parts of Java into the container

### Install a container on an M3 device
Use the web interface of your M3 device:

- Menu "Administration -> Container": 
	- Either click the <b>magic wand</b> to create a new container
	- or upload a container from [https://m3-container.net](https://m3-container.net/M3_Container/images)
- Click the <b>pencil</b> to get to the settings of the new container
- Select a <b>net interface</b> to which the containers network interface should be bridged
- Enter at least an <b>IPv4 address</b> and its <b>netmask</b>
- Store the settings and activate the profile with a click on the <b>blinking gear</b> 

Now you should be able to ping the container. It's assumed the container gets bridged to "net1" and has the IP address 192.168.1.3/24. Open a console and try:
<pre>
joe@pc ~/ <b>ping 192.168.1.3</b>
</pre>

In case this is successful the next step is to establish an SSH connection to the container as user "root" with password "root":
<pre>
joe@pc ~/ <b>ssh root@192.168.1.3</b>
</pre>
Login by typing the password "root". It's <b>highly recommended to change the password</b> of root with the command "passwd". 

### Download and install Java
Oracle offers its JRE 8 (Java Runtime Environment) precompiled for ARMv7 within the JDK (Java Development Kit)

- Navigate your browser to [http://www.oracle.com/technetwork/java/javase/downloads](http://www.oracle.com/technetwork/java/javase/downloads). 
- Click the Java 8 JDK download button (e.g. after "Java SE 8u144")
- Accept the "Oracle Binary Code License Agreement for Java SE"
- Download the version for <b>Linux ARM 32 Hard Float ABI</b> (click jdk-8-XXXX-linux-arm32-vfp-hflt.tar.gz")

- Unpack the downloaded image on your PC 
<pre>
joe@pc ~/ <b>tar xf jdk-8u144-linux-arm32-vfp-hflt.tar.gz </b>
</pre>

- Enter the "jre" directory of the extracted directory:
<pre>
joe@pc ~/ <b>cd jdk1.8.0_144/jre</b>
</pre>

- Transfer all files into the container on the M3 device:
<pre>
joe@pc ~/ <b>scp -r * root@192.168.1.3:/</b>
</pre>
Alternatively you can pack the content of this directory, transfer it to the container and extract it in its / directory.

### Run your first Java application
Create a file with the name "HelloWorld.java" on your PC:
<pre>
joe@pc ~/ <b>nano HelloWorld.java</b>
</pre>

Copy and paste this Code:
Create a file with the name "HelloWorld.java" on your PC:
<pre>
public class HelloWorld
{
    public static void main (String[] args)
    {
        System.out.println("Hello World!");
    }
}
</pre>

Store and exit the editor. Run the Java compiler, which will create a .class file containing the program, that the java virtual machine can handle:
<pre>
joe@pc ~/ <b>javac HelloWorld.java</b>
</pre>

Transfer the binary file HelloWorld.class file into the container:
<pre>
joe@pc ~/ <b>scp HelloWorld.class root@192.168.1.3:~</b>
</pre>

Log in to your container and start the application:
<pre>
joe@pc ~/ <b>ssh root@192.168.1.3</b>
root@container_d4273e3d ~  $ <b>java HelloWorld</b>
</pre>

### Finished!
Your Java container is ready, you can use it as a template container for future Java projects. Done!

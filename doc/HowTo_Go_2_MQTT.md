# Container Application Development with Go

## MQTT Sample Application

### Introduction
This demo shows how to setup a MQTT broker service and a container 
application written in Go. The demo uses the [Mosquitto](http://www.mosquitto.org/ "Mosquitto")
service on a Mosqiottp MQTT broker container or on an Ubuntu linux server and the Paho Go Client for the MQTT connection.

Consider following MQTT connection settings:
- Topic: first/demo
- Username: joe
- Password: secret

<br>

## Table of contents

>1a) &nbsp;&nbsp;<a href="#setup_container">Setup a container with the MQTT broker service</a><br>
1b) &nbsp;&nbsp;<a href="#setup_ubuntu">Setup the MQTT broker service on an Ubuntu server</a><br>
2 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#create_pub">Create the MQTT publisher for your container</a>

<br> 
<br>

### <p id="setup_container">1a) Setup a container with the MQTT broker service</p>

#### 1. Install SDK
Follow the instructions in the [Install guide](https://github.com/insys-icom/M3_Container/blob/master/doc/Install_Virtualbox.md "Install Virtualbox") to setup the SDK.

#### 2. Create container with MQTT broker service
To create a container with a mosquitto MQTT broker service follow these steps:<br>
##### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.1 Start virtualbox with your SDK
##### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.2 Change to the root directory of the git repository (most likely *~/M3_Container*) 
<pre>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>$ cd ~/M3_Container</b>
</pre>

##### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.3  Use this build script to cross compile all necessary software and create an update packet with the final container
<pre>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>$ ./scripts/create_container_mosquitto_mqtt_broker.sh</b>
</pre>

#### 3. Import container
Now startup your MRX device and login to the webinterface.<br> 
Go to */Administration/Container*, click the *choose file button* and select the created container (see *~/M3_Container/images/* in your git repository).<br>
After that configure *Bridge to Net* and *IP address* of the container.

#### 4. Configure MQTT Broker service
Now open a new tab and type in the IP address of the MQTT broker container.
The overview page shows you how to configure the service.

### <p id="setup_ubuntu">1b) Setup the MQTT broker service on an Ubuntu server</p>
Start an Ubuntu 14.04 instance and setup the Mosquitto MQTT service as described below. This demonstration uses a [Digital Ocean](https://www.digitalocean.com/ "Digital Ocean") droplet.

#### 1. Create user "mosquitto"
The Mosquitto process should run as a normal user and not as root.
<pre>
$ <b>adduser mosquitto</b>
</pre>

#### 2. Install Mosquitto
Update the Ubuntu repositories and install Mosquitto dependencies.
<pre>
$ <b>apt-get update</b>
$ <b>apt-get install build-essential libwrap0-dev libssl-dev libc-ares-dev uuid-dev xsltproc</b>
</pre>

Download the latest Mosquitto sources, compile and install them.
<pre>
$ <b>sudo - mosquitto</b>
$ <b>wget http://mosquitto.org/files/source/mosquitto-1.4.10.tar.gz</b>
$ <b>tar xvzf mosquitto-1.4.10.tar.gz</b>
$ <b>cd mosquitto-1.4.10</b>
$ <b>make</b>
$ <b>exit</b>
$ <b>cd /home/mosquitto/mosquitto-1.4.10</b>
$ <b>make install</b>
</pre>

The binaries are now available under /usr/local

#### 3. Setup Mosquitto
Create the Mosquitto user "joe" for the demo application.
<pre>
$ <b>mosquitto_passwd -c /etc/mosquitto/pwfile joe</b>
</pre>

Enter the password as described under section "Introduction".

Create the Mosquitto database directory.
<pre>
$ <b>mkdir /var/lib/mosquitto/</b>
$ <b>chown mosquitto:mosquitto /var/lib/mosquitto/ -R</b>
</pre>

Create your Mosquitto configuration file.
<pre>
$ <b>cp /etc/mosquitto/mosquitto.conf.example /etc/mosquitto/mosquitto.conf</b>
$ <b>vi /etc/mosquitto/mosquitto.conf</b>
</pre>

Add following configuration at the end of the configuration file.
```
listener 8883 <your-server-ip-address>
persistence true
persistence_location /var/lib/mosquitto/
persistence_file mosquitto.db
log_dest syslog
log_dest stdout
log_dest topic
log_type error
log_type warning
log_type notice
log_type information
connection_messages true
log_timestamp true
allow_anonymous false
password_file /etc/mosquitto/pwfile
```

Run once.
<pre>
$ <b>/sbin/ldconfig</b>
</pre>

#### 4. Configure and start Mosquitto service
Test your Mosquitto binaries.
<pre>
$ <b>mosquitto -c /etc/mosquitto/mosquitto.conf</b>
</pre>
This command should run without errors. Open another window, start a new SSH 
session to your Ubuntu server and try to connect to the Mosquitto service.
<pre>
$ <b>mosquitto_sub -h &lt;your-server-ip&gt; -p 8883 -v -t 'first/demo' -u joe -P secret</b>
</pre>
If you're successfully connected, no errors appears and the Mosquitto service
logs a successful connection.

Stop both processes and create an Upstart service.
<pre>
$ <b>vi /etc/init/mosquitto.conf</b>
</pre>
Paste following content into the file:
```
description "Mosquitto MQTT broker"
start on net-device-up
respawn
exec /usr/local/sbin/mosquitto -c /etc/mosquitto/mosquitto.conf
```
Start the service with:
<pre>
$ <b>service mosquitto start</b>
</pre>

You're running a MQTT broker, now!


###  <p id="create_pub">Create the MQTT publisher for your container</p>

On your Go development machine install the Paho Go Client.
<pre>
$ <b>go get github.com/eclipse/paho.mqtt.golang</b>
</pre>

Create a new Go source file "mqttpub.go" and paste following source code. 
Replace the IP address with your Ubuntu server address.
```go
package main

import (
	"fmt"
	"time"
	//import the Paho Go MQTT library
	MQTT "github.com/eclipse/paho.mqtt.golang"
)

func main() {
	opts := MQTT.NewClientOptions().AddBroker("tcp://<your-server-ip-address>:8883")
	opts.SetClientID("insys")
	opts.SetUsername("joe")
	opts.SetPassword("secret")

	c := MQTT.NewClient(opts)
	if token := c.Connect(); token.Wait() && token.Error() != nil {
		panic(token.Error())
	}

	for i := 0; i < 5; i++ {
		text := fmt.Sprintf("this is msg #%d!", i)
		token := c.Publish("first/demo", 0, false, text)
		token.Wait()
	}

	time.Sleep(3 * time.Second)

	c.Disconnect(250)
}
```

Open a SSH session on your Ubuntu based MQTT server and start a test
subscriber process.
<pre>
$ <b>mosquitto_sub -h &lt;your-server-ip-address&gt; -p 8883 -v -t 'first/demo' -u joe -P secret</b>
</pre>

If your development machine has a full connection to the Ubuntu server, run the
application locally first.
<pre>
$ <b>go run mqttpub.go</b>
</pre>

You should see on the Ubuntu server session following output:
```
first/demo this is msg #0!
first/demo this is msg #1!
first/demo this is msg #2!
first/demo this is msg #3!
first/demo this is msg #4!
```

Build on Mac OS X:
<pre>
$ <b>cd /Users/maxmuster/go/src/github.com/maxmuster.de/mqtt/mqttpub.go</b>
$ <b>env GOOS=linux GOARCH=arm GOARM=7 go build -v /Users/maxmuster/go/src/github.com/maxmuster.de/mqtt/mqttpub.go</b>
</pre>

Build on Linux:
<pre>
$ <b>cd ~/mqtt</b>
$ <b>GOPATH=$(pwd -P) go get github.com/eclipse/paho.mqtt.golang</b>
$ <b>GOPATH=$(pwd -P) GOOS=linux GOARCH=arm GOARM=7 go build -v mqttpub.go</b>
</pre>

Copy the binary and execute the application on the container. 

<pre>
$ <b>scp mqttpub root@&lt;your-container-ip-address&gt;:~/</b>
$ <b>ssh root@&lt;your-container-ip-address&gt;</b>
password: *****
root@container-1234 ~  $ <b>./mqttpub</b>
</pre>

Your subscriber should show the same output as the previous run on your
local machine. Your sucessfully running a MQTT client, written on Go, 
inside your container. Done!

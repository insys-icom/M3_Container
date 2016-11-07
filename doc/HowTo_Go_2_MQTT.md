# Container Application Development with Go

## MQTT Sample Application

### Introduction
This demo shows how to setup a MQTT broker service and a container 
application written in Go. The demo uses the [Mosquitto](http://www.mosquitto.org/ "Mosquitto")
service on a Mosqiottp MQTT broker container and the Paho Go Client for the MQTT connection.

Consider following MQTT connection settings:
- Topic: first/demo
- Username: joe
- Password: secret 

### Setup container with MQTT broker service

#### 1. Install SDK
Follow the instructions in the [Install guide](https://github.com/insys-icom/M3_Container/blob/master/doc/Install_Virtualbox.md "Install Virtualbox") to setup the SDK.

#### 2. Create container with MQTT broker service
To create a container with a mosquitto MQTT broker service follow these steps:<br>
##### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.1 Start virtualbox with your SDK
##### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.2 Change to the root directory of the git repository (most likely *~/M3_Container*) 
<pre>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>cd ~/M3_Container</b>
</pre>
##### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.3  Use this build script to cross compile all necessary software and create an update packet with the final container
<pre>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$ <b>./scripts/create_container_mosquitto_mqtt_broker.sh</b>
</pre>

#### 3. Import container
Now startup your MRX device and login to the webinterface.<br> 
Go to */Administration/Container*, click the *choose file button* and select the created container (see *~/M3_Container/images/* in your git repository).<br>
After that configure *Bridge to Net* and *IP address* of the container.

#### 4. Configure MQTT Broker service
Now open a new tab and type in the IP address of the MQTT broker container.
The overview page shows you how to configure the service.

### Create the MQTT publisher for your container

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

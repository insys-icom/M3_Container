# Container Application Development with Go

## Accessing the Cumulocity REST-API - Part 1

### Introduction
This demo shows how to consume a JSON-based REST-API with Go. In this 
demonstration we use the Cumulocity REST-API to add a new measurement to an 
existing device. The main purpose of this sample is to show how to convert
data to JSON and access a REST-API with Go. The JSON output we send to the
Cumulocity server should look like this:
```JSON
{
    "source":
    {
        "id": "<my-device-id>"
    },
    "time": "2016-09-21T20:18:30.323634999+02:00",
    "type": "MyWeatherMeasurementDemo",
    "WeatherData":
    {
        "Weather Station Regensburg":
        {
            "unit": "°C",
            "value": 20.9
        }
    }
}
```

> **INFO**
> Cumulocity provides a very complex and powerful REST interface. 
> To keep things simple we declare our JSON schema statically. 
> This is not the recommended way to access Cumulocity because of it's 
> dynamic nature. A future demo will explain the data structure of 
> Cumulocity and shows a dynamic approach how to access the Cumulocity
> REST-API properly. 

> **REQUIREMENTS**
> You need a Cumulocity account and a device in your inventory. Cumulocity
> offers a 30 day free trial at 
> [www.cumulocity.com](http://www.cumulocity.com "Cumulocity"). After 
> successful registration you can add a new device with a simple REST-API call.
> Use "curl" or the Postman add-on for Google Chrome. Please read the
> [Cumulocity Hello REST! developers guide](http://cumulocity.com/guides/rest/hello-rest/ "Hello REST!")

To run this sample application you need:
- a Cumulocity sub-domain &lt;my-subdomain&gt;
- a Cumulocity username &lt;my-username&gt;
- a Cumulocity password &lt;my-password&gt;
- a Cumulocity device ID &lt;my-device-id&gt;

### Sample application
The following sample application adds a new measurement through the
Cumulocity REST-API to a device. Everything you need to run this application
is already included in Go. First we describe our data structure with Go. 
Inside main we are populating the data structure with real data and convert it
to JSON. We're creating a HTTP request with all required settings, 
especially the HTTP header variables and the authentication settings. If 
everything is setup right, the HTTP call runs without errors and a few seconds 
later you can see a new measurement on the Cumulocity UI.

```Go
package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"time"
)

// SourceObject is a reference to a Cumulocity managedObject
// Inside the Cumulocity UI a managedObject is a device
type SourceObject struct {
	ID  string `json:"id"`
	URI string `json:"self,omitempty"`
}

// MeasurementHeader contains all mandatory data fields that are included
// in a measurement struct
type MeasurementHeader struct {
	ID        string       `json:"id,omitempty"`
	URI       string       `json:"self,omitempty"`
	Source    SourceObject `json:"source"`
	TimeStamp string       `json:"time"`
	Type      string       `json:"type"`
}

// MeasurementValue stores a value of a measurement
type MeasurementValue struct {
	Unit  string  `json:"unit"`
	Value float32 `json:"value"`
}

// MyWeatherData is the dynamic part of a measurement request
type MyWeatherData struct {
	MyWeatherStation MeasurementValue `json:"Weather Station Regensburg"`
}

// MyWeatherMeasurementDemo JSON request
type MyWeatherMeasurementDemo struct {
	MeasurementHeader               // Inherit all fields from MeasurementHeader
	Data              MyWeatherData `json:"WeatherData"`
}

func main() {
	// Populate a weather measurement object
	m := MyWeatherMeasurementDemo{}
	m.Source.ID = "<my-device-id>" // Set your Device-ID here
	m.TimeStamp = time.Now().Format(time.RFC3339Nano)
	m.Type = "MyWeatherMeasurementDemo" // Our user-defined type
	m.Data.MyWeatherStation.Unit = "°C"
	m.Data.MyWeatherStation.Value = 20.9

	// Create the request body data
	body := new(bytes.Buffer)
	err := json.NewEncoder(body).Encode(m)
	if err != nil {
		log.Fatalf("Could not marshal data to JSON.")
	}

	// This line prints out the marshalled JSON data. It should equals
	// the JSON output as described in the example documentation.
	log.Printf("MyWeatherMeasurementDemo JSON data: %v", body.String())

	// Initialize the HTTP POST request.
	// Replace the Cumulocity domain name with your settings.
	url := "http://<my-subdomain>.cumulocity.com/measurement/measurements/"
	client := &http.Client{}
	req, err := http.NewRequest("POST", url, body)
	if err != nil {
		log.Fatalf("Could not create a HTTP request object. Error: %v", err)
	}

	// Set your credentials to access
	req.SetBasicAuth("<my-username>", "<my-password>")

	// This setting is needed to create a measurement request.
	// Please read the Cumulocity REST-API documentation for more informations.
	req.Header.Set("Content-Type", "application/vnd.com.nsn.cumulocity.measurement+json;charset=UTF-8;ver=0.9")

	// Call the Cumulocity REST-API function to add the measurement
	_, err = client.Do(req)
	if err != nil {
		log.Fatalf("The HTTP request failed. Error: %v", err)
	}

	fmt.Println("Succesfully added the measurement to Cumulocity.")
}
````

### Run this application inside your container
You need to build a ARM
binary as described in the Quick Start Guide. In case of a Mac OS X based
development workstation run:
<pre>
$ <b>env GOOS=linux GOARCH=arm GOARM=7 go build -v /Users/maxmuster/go/src/github.com/maxmuster.de/cumulocity/cumulocity.go</b>
$ <b>scp cumulocity root@&lt;your-container-ip-address&gt;:~/</b>
$ <b>ssh root@&lt;your-container-ip-address&gt;</b>
password: *****
root@container-1234 ~  $ <b>./cumulocity</b>
2016/09/21 21:20:48 MyWeatherMeasurementDemo JSON data: {"source":{"id":"*****"},"time":"2016-09-21T21:20:48.98678944+02:00","type":"MyWeatherMeasurementDemo","WeatherData":{"Weather Station Regensburg":{"unit":"°C","value":10.8}}}
Successfully added the measurement to Cumulocity.
</pre>

> **IMPORTANT**
> Don't use a HTTPS (SSL) connection at the moment. There's an error inside
> the container when trying to access the Cumulocity through HTTPS. We're 
> working on this issue. 

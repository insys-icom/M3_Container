# Container Application Development with Go

## Quick Start Guide

### Introduction
Go (golang) is a very intuitive programming language, which is comparable
to C and creates statically linked binaries for several 
architectures. Go is designed for efficient, high performing and low latency 
server applications. With Go you can create ARM binaries which run inside a 
container without any dependencies. Build, copy and run. 

For more information about Go, visit [www.golang.org](https://golang.org/ "Go").     

### Setup Development Environment
Download and setup Go on your computer. You can find binaries for Windows,
Mac OS X and Linux [here](https://golang.org/dl/ "Go Downloads"). If you're 
running Linux you can install Go through the package manager, too. On Ubuntu or 
Debian try:
<pre>
sudo apt-get install golang
</pre>

Point the GOROOT environment variable to your Go installation directory. 
Create a "go" sub-directory inside your home directory and set your GOPATH
environment variable to this directory.

Windows example:
<pre>
C:\> <b>set GOROOT=C:\go</b>
C:\> <b>set GOPATH=C:\Users\maxmuster\go</b>
</pre>

Add Go bin directory to your path. On Windows execute:
<pre>
C:\> <b>set PATH=%PATH%;%GOROOT%\bin</b>
</pre>

Check your Go version:
<pre>
C:\> <b>go version</b>
go version go1.6.3 windows/amd64
</pre>
**Ensure that your running Go version 1.5 or above!**

Now you're ready to create your first Go application for a container.

### Hello World Application
Change to your go directory inside your home directory and create a "src" 
directory:
<pre>
C:\> <b>cd Users\maxmuster\go</b>
C:\Users\maxmuster\go> <b>mkdir src\maxmuster.de\hello</b>
</pre>

Open your favourite text editor, copy and paste the following source code and
save the file inside the previously created source directory. Name the source 
file: hello.go
```go
package main

import "fmt"

func main() {
	fmt.Println("Hello World")
}
```

You can execute the application on your local computer to check for errors
and that your application runs as considered. 
<pre>
C:\Users\maxmuster\Go> <b>go run src\maxmuster.de\hello\hello.go</b>
Hello World
</pre>

To build an ARM binary for your container, you need to specify the 
target before running the "go build" command. In the case of an container
the environment variable GOOS is set to "linux", GOARCH is set to "arm" and 
GOARM is set to "7" for ARMv7 support with hard-floats.  
<pre>
C:\Users\maxmuster\Go> <b>set GOOS=linux</b>
C:\Users\maxmuster\Go> <b>set GOARCH=arm</b>
C:\Users\maxmuster\Go> <b>set GOARM=7</b>
C:\Users\maxmuster\Go> <b>go build src\maxmuster.de\hello\hello.go</b>
C:\Users\maxmuster\Go> <b>dir</b>
19.09.2016  14:23    &lt;DIR&gt;          .
19.09.2016  14:23    &lt;DIR&gt;          ..
13.09.2016  09:28    &lt;DIR&gt;          bin
<b>19.09.2016  14:23         1.854.112 hello</b>
22.07.2016  09:59    &lt;DIR&gt;          pkg
19.09.2016  14:06    &lt;DIR&gt;          src
</pre>

Using Linux it is possible to do everything in just one line. Enter the directory
of your hello world project and run:
<pre>
user@machine ~/hello $ <b>GOPATH=$(pwd -P) GOOS=linux GOARCH=arm GOARM=7 go build hello.go</b>
</pre>

After successfully building you can see a 1.8 MB large hello file inside your 
current directory. You can transfer this file via SCP to your container and 
execute it. 
<pre>
root@container-1234 ~  $ <b>./hello</b>
Hello World!
</pre>

Your first container application, written in Go, is running. Done!

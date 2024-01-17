# Container Application Development with C#


## Introduction
C# is a programming language with huge tooling support.
In the past it was necessary to install a runtime environment to be able to execute C# binaries.
This has changed, it now is possible to create single file binaries without having the huge runtime installed.
Now it becomes more feasable to use this language for containers.
The .NET SDK comes with all necessary compiler and tools, so no third party SDK is necessary any more.

This HowTo should describe the minimal necessary steps to get a C# program to run within a container.
It deliberatley doesn't use fancy editors or other tools except the dotnet SDK.

For more information about Go, visit [https://learn.microsoft.com/en-us/dotnet](https://learn.microsoft.com/en-us/dotnet "Mircosoft .NET docu").

The steps to get to a simple "hello world" binary would be:
- Install dotnet SDK on the local PC
- Create a new console project
- Configure build process
- Compile the project
- Install a minimal container on the router
- Transfer the file into the minimal container
- Execute the binary

### Install dotnet SDK on the local PC
Download the latest SDK: [https://dotnet.microsoft.com/en-us/download](https://dotnet.microsoft.com/en-us/download "Microsoft Downloads").

If you're running Linux you can install it with the package manager, too.
On Ubuntu or Debian try:
<pre>
  ~/hello $ <b>sudo apt-get install dotnet-sdk-8.0</b>
</pre>

### Create a new console project
Create a new directory, enter it and let the SDK create a new console project for you:
<pre>
  ~ $ <b>mkdir hello</b>
  ~ $ <b>cd hello</b>
  ~/hello $ <b>dotnet new console</b>
</pre>

### Configure build process
In order to produce a single file binary, that can executed in a container on a router, the compiler has to cross compile for the armv7 architecture instead for x86 or x86_64.
Additionally the need for an installed .NET runtime environment installed in the container should be avoided.

Edit the existing project description file <b>"hello.csproj"</b> with our favourite editor:

```xml
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <OutputType>Exe</OutputType>
    <Nullable>enable</Nullable>
    <TargetFramework>net8.0</TargetFramework>
    <RootNamespace>hello</RootNamespace>
    <ImplicitUsings>enable</ImplicitUsings>

    <SelfContained>true</SelfContained>
    <PublishSingleFile>true</PublishSingleFile>
    <RuntimeIdentifier>linux-arm</RuntimeIdentifier>
    <InvariantGlobalization>true</InvariantGlobalization>
    <EnableCompressionInSingleFile>true</EnableCompressionInSingleFile>
    <PublishTrimmed>true</PublishTrimmed>

  </PropertyGroup>
</Project>
```

The additional settings are:
- SelfContained: A single binary file should be created
- PublishSingleFile: The binary should contain all necessary files from the runtime
- RuntimeIdentifier: The binary should be cross compiled to run on linux-arm
- InvariantGlobalization: Do not use localization, which would create a dependency to libicu
- EnableCompressionInSingleFile: Reduce size of the binary by compressing it
- PublishTrimmed: Reduce size of the binary by removing not needed librarys of the runtime

### Compile the project
As all necessary build options already are defined within the project file, the command to compile is very short:
<pre>
    ~/hello $ <b>dotnet publish</b>
</pre>
If the program compiled successfully, the output will tell the path to the final binary.

### Install a minimal container on the router
Download a recent [default container](https://m3-container.net/M3_Container/images/container_default.tar "Default Container"), upload it to your router and configure it.
It's assumed, that the containers net interface is bridged to net1 of the router and the IP address is 192.168.1.3/24.

###  Transfer the file into the minimal container
The compiled binary must now be transfered to the container.
The default container runs an SSH server by default.
<pre>
    ~/hello $ <b>scp -O bin/Release/net8.0/linux-arm/publish/hello root@192.168.1.3:/bin/</b>
</pre>

### Execute the binary
Log in at the container and execute the new binary.
In default settings user name and password are both "root".
Please change this as soon as possible and think about eventually using keys.
<pre>
    ~/hello $ <b>ssh root@192.168.1.3</b>
    root@192.168.1.3's password: <b>root</b>
    root@container_default ~ $ <b>/bin/hello</b>
    Hello, World!
</pre>

Your first container application, written in C#, is running. Done!

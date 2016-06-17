This repository contains scripts to make cross compiling for M3 containers more easy.

That's the plan:

                     get the SDK -----> | <-------- get this repo
                                        |
                                        |
                                        V
                            build scripts use SDK to
                       create binaries and final container

1) Get SDK
- Install [VirtualBox](https://virtualbox.org)
- Get our [SDK](https://www.insys-icom.de/smartbox/M3_SDK_2.ova) which is a VirtualBox Image
- import the SDK-Appliance into VirtualBox

2) Clone this repository on your host: `> git clone git@github.com:insys-icom/M3_Container.git`

3) Give VirtualBox access to the locally installed repository using the "shared folder" feature of VirtualBox

4) Log into SDK and create your first container: `> cd M3_Container; ./scripts/mk_container`

Further documentation and details are located in simple text files within /doc of this repository. Please start with reading "1st_steps.md".

HowTo create a new container
============================

For all following examples it is assumed that you changed the directory to the root of the git repository, which is most of the time "~/M3_Container".

In short
--------
1. Use ./oss_sources/scripts/*.sh build scripts to cross compile open source projects
2. Optionally compile your own applications in ./closed_sources/*
3. Pack the container with ./scripts/mk_container.sh and a ./scripts/rootfs_list/*txt file to define the files that should be copied into a container


Comfortable
-----------
There already are a few recepts for complete containers called "create_container_XYZ.sh" located in the directory "scripts". These scripts will try to get the sources, configure and compile them and pack a complete container without more interaction with the user. They always build the complete content of a container in the correct order, so all dependencies of the projects to build are satisfied. This scripts can be used as a template for own containers.


Detailed
--------
The build scripts located in ./oss_sources/scripts/*.sh are used to download, configure and compile the open source projects. A build script needs one of the parameters "all", "download", "check_source", "unpack", "configure", "compile", "install_staging" or "uninstall_staging".

This parameters are functions that optionally can exist in a build script, they are not mandatory. If a build script lacks one of the functions, a generic function will do its default action.

The build script are named after the package they will try to compile. They should be very specific and contain something like a version, so that build scripts for newer/older versions of the same project can be built.

1.  "all"
    This parameter of a build script will try all steps from getting the sources up to installing the binaries

2.  "download"
    This parameter is used to get the sources of the open source project. In the beginning of the build script the variable "PKG_DOWNLOAD" contains the location of the open source packet archive. The packet will be stored in "oss_sources/dl" with the file name that is set to the variable "PKG_ARCHIVE_FILE" in the beginning of the build script. If there already is a file with that name the download will not happen.
    
3.  "check_sources"
    The MD5 checksum of the downloaded sources are checked. The variable "PKG_CHECKSUM" in the beginning of a build script must contain the expected MD5 sum. The variable "PKG_ARCHIVE_FILE" contains the file name that must be located in "./oss_sources/dl/". This check is highly recommended to avoid using defective or incomplete source archives. If you do not want to check the sources, you will have to set PKG_CHECKSUM="none" 

4.  "unpack"
    The archive must get unpacked to "./working" for the following steps. In the beginning of the build script the variable "PKG_DIR" defines the directory within "./working" where the sources will be extracted to. This directory name should be named similar to the build script and the open source project.
    
5.  "configure"
    This function prepares the sources for the next step - compilation. If the directory named after $PKG_DIR in the directory "./oss_packages/src/" exists, and the function "copy_overlay" is called, all files in that directory are copied into the working directory. This will replace the files of the original project if there already are files with the same name. This way the sources can be modified. Important: Never change files in the working directory manually as long as you are not perfectly aware of this mechanism! When there is no such directory the source stay unmodified. Most of the time the "configure" function of a build script will call ".configure" in the working directory and prepare the sources for compilation. This is the chance to modify compile options or the feature set for the packet. Dependend on the packet the configure function will contain different lines. Use the existing build scripts to get inspired.
    
6. "compile"
    This function also can start with the function "copy_overlay" as described in the paragraph above. This can modify the sources after "configuring" them. Most of the time the compile function will result binaries in a new directory called "./working/PKG_DIR/install". The binaries are still unstripped.
    
7. "install_staging"
    This function will copy files to the directory "./rootfs_staging". This directory is a collection of unmodified files, to offer them to other build scripts which need a link to these files within their "configure" step. A example for such a dependency are open source libraries. Build scripts of a library (e.g. openssl) install the header files and the binary library to "./rootfs_staging". Build scripts (e.g.) stunnel) need these header files to get configured. All files copied to "./rootfs_staging" are still unstripped.
    
8. "uninstall_staging"
    This function reverts "install_staging". It removes all files copied to "./rootfs_staging". This would be necessary if a newer version of a library had no longer a certain header file.

After compiling all needed open source binaries the own closed sources should be compiled. As this is an optional step and every closed source project can have different requirements for their compilation this is all left in the hand of the developer. It is recommended to have Makefiles or scripts similar to build scripts above. The files should be copied to rootfs_staging.

The final step is packaging everything to an update packet that can be stored and installed on a router. The script "./scripts/mk_container.sh" packs everything and stores the final update packet in "./images". The script will create directory "./working/rootfs_target/rootfs", which will contain all files for the root file system of the container. It copies every file from "./rootfs_skeleton" as the basic structure into that working directory. Afterwards files will get copied to the working directory that are listed in a "rootfs_list.txt" file. These lists are located in "./scripts/rootfs_lists". They get interpreted by the script "./scripts/gen_initramfs_list.sh". The advantage is, that the permissions and ownership of that files can be modfied without the need of being root on the local machine and the ability, to create links.

To get more information get the help of the script: "./scripts/mk_container.sh -h":
    -n  name of the update packet with container to be packed
    -l  use this file in the directory "./scripts/rootfs_lists/" to fill the root file system of container
    -k  use this RSA key in the directory "./scripts/keys/" to encrypt the container
    -d  use that description within MANIFEST
    -v  use that version string within MANIFEST

After packing the root file content the script creates an update packet with a MANIFEST file. Optionally the root file system can be encrypted. In that case a random key is generated and the root file system gets encrypted with AES 256. The randomly generated key gets encrypted with a RSA key pair. The public part of the RSA key pair must exist on the router in order to be able to decrypt the update packet. The RSA key pairs to be used have to be stored in "./scripts/keys/". If there is no key pair, the script will create a new one and store it there.    

# HowTo create a new container

For the following it's assumed that you

* started and configured the SDK to have internet access
* logged into the SDK as "user" (password is also "user")
* changed to the root directory of the git repository, which is most likely "/home/user/M3_Container"

## For beginners: The comfortable way
There already are a few recipes for creating complete containers in "./scripts/", like "create_container_default.sh". These scripts will try to download the sources, configure and compile them and pack a complete container without any more interaction with the user. They always build the complete content of a container in the correct order, so all dependencies of the projects to be built are satisfied. This scripts can be used as a template for own containers.

This is an example, that will create a small container with an SSH server:
<pre>
user@m3sdk ~/M3_Container $ <b>./scripts/create_container_default.sh</b>
</pre>


## For advanced: In short
1. Use ./oss_sources/scripts/*.sh build scripts to cross compile open source projects
2. Optionally compile your own applications in ./closed_sources/*
3. Create a list ./scripts/rootfs_list/*.txt defining all files to be copied into the container
3. Create the update packet with the container with ./scripts/mk_container.sh


## For experts: Detailed instructions for creating containers
The build scripts located in ./oss_sources/scripts/*.sh are used to download, configure and compile the open source projects. A build script needs one of the parameters "all", "download", "check_source", "unpack", "configure", "compile", "install_staging" or "uninstall_staging".

This parameters are functions that optionally can exist in a build script, they are not mandatory. If a build script lacks one of the functions, a generic function will do its default action.

The build script are named after the package they will try to compile. They should be very specific and contain something like a version, so that build scripts for newer/older versions of the same project can be built.

If building an open source project using one of these scripts fails, a missing dependency might be the reason. This is often the case when an open source package needs external libraries like openssl. That is the reason it might be important to compile the packages within the right order.

1.  "all"<br>
    This parameter of a build script will try all steps from getting the sources up to installing the binaries

2.  "download"<br>
    This parameter is used to get the sources of the open source project. In the beginning of the build script the variable "PKG_DOWNLOAD" contains the location of the open source packet archive. The packet will be stored in "oss_sources/dl" with the file name that is set to the variable "PKG_ARCHIVE_FILE" in the beginning of the build script. If there already is a file with that name the download will not happen.

3.  "check_sources"<br>
    The MD5 checksum of the downloaded sources are checked. The variable "PKG_CHECKSUM" in the beginning of a build script must contain the expected MD5 sum. The variable "PKG_ARCHIVE_FILE" contains the file name that must be located in "./oss_sources/dl/". This check is highly recommended to avoid using defective or incomplete source archives. If you do not want to check the sources, you will have to set PKG_CHECKSUM="none"

4.  "del_working"<br>
	The directory with an eventually already unpacked (next step) archive in "./working" will be deleted. This is a precaution for the next step, so that only the archives files exist.

5.  "unpack"<br>
    The archive must get unpacked to "./working" for the following steps. In the beginning of the build script the variable "PKG_DIR" defines the directory within "./working" where the sources will be extracted to. This directory name should be named similar to the build script and the open source project.

6.  "configure"<br>
    This function prepares the sources for the next step - compilation. If the directory named after $PKG_DIR in the directory "./oss_packages/src/" exists, and the function "copy_overlay" is called, all files in that directory are copied into the working directory. This will replace the files of the original project if there already are files with the same name. This way the sources can be modified. Important: Never change files in the working directory manually as long as you are not perfectly aware of this mechanism! When there is no such directory the source stay unmodified. Most of the time the "configure" function of a build script will call ".configure" in the working directory and prepare the sources for compilation. This is the chance to modify compile options or the feature set for the packet. Depending on the packet the configure function will contain different lines. Use the existing build scripts to get inspired.

7. "compile"<br>
    This function also can start with the function "copy_overlay" as described in the paragraph above. This can modify the sources after "configuring" them. Most of the time the compile function will result binaries in a new directory called "./working/PKG_DIR/install". The binaries are still unstripped.

8. "install_staging"<br>
    This function will copy files to the directory "./rootfs_staging". This directory is a collection of unmodified files, to offer them to other build scripts which need a link to these files within their "configure" step. A example for such a dependency are open source libraries. Build scripts of a library (e.g. openssl) install the header files and the binary library to "./rootfs_staging". Build scripts (e.g.) stunnel) need these header files to get configured. All files copied to "./rootfs_staging" are still unstripped.

9. "uninstall_staging"<br>
    This function reverts "install_staging". It removes all files copied to "./rootfs_staging". This would be necessary if a newer version of a library had no longer a certain header file.

After compiling all needed open source binaries the own closed sources should be compiled. As this is an optional step and every closed source project can have different requirements for their compilation this is all left in the hand of the developer. It is recommended to have Makefiles or scripts similar to build scripts above. The final files should be copied to rootfs_staging.

The final step is packaging everything to an update packet that can be stored and installed on a router. This is done by "./scripts/mk_container.sh":
<pre>
$ ./scripts/mk_container.sh -l default.txt -n "My_first_container" -v 1.0
</pre>

The script packs all files and stores the resulting update packet in "./images". To be able to do that the script will create the directory "./working/rootfs_target/rootfs". A list with copy instructions is used to define the files that should be copied into the final container. This list is located in ./scripts/rootfs_lists/. Every line contains a file, directory or symlink to be copied or created. Each entry must be given the read/write/execute permissions and the ownership. This way a container can be created by a normal user, no root permission are necessary.

To get more information about the the script use: "./scripts/mk_container.sh -h":
    -n  name of the update packet with container to be packed
    -l  use this file in the directory "./scripts/rootfs_lists/" to fill the root file system of container
    -k  use this RSA key in the directory "./scripts/keys/" to encrypt the container
    -d  use that description within MANIFEST
    -v  use that version string within MANIFEST

Optionally the root file system can be encrypted. In that case a random key is generated and the root file system gets encrypted with AES 256. The randomly generated key gets encrypted with a RSA key pair. The public part of the RSA key pair must exist on the router in order to be able to decrypt the update packet. The RSA key pairs to be used have to be stored in "./scripts/keys/". If there is no key pair, the script will create a new one and store it there.

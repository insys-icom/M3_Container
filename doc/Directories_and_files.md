This repository offers the directory structure and scripts to create new containers with the M3SDK.
The variable <ARCH\> is a subdirectory for the different architectures, currently "armv7" or "amd64".

Overview of the directories
===========================
./closed_packages
> A place where customers applications are sourced that are not Open Source.

./doc
> Help texts, FAQs and links to further help.

./images/<ARCH\>
> Final container images get packed and stored here in form of update packages.

./oss_packages
> Open Source projects and their build script are located here.

./oss_packages/dl
> The downloaded sources of packages are stored here.

./oss_packages/scripts
> The Open Source projects are built with these scripts.

./oss_packages/scripts/helpers
> Helping scripts for the build scripts are located here.

./oss_packages/src
> In case the project to be built has to be modified with patches or own modifications, the
modified files are stored here. These files replace the files of the original project before it gets build.

./rootfs_skeleton
> Files stored here are static files, that can be copied into containers.

./rootfs_staging/<ARCH\>
> Build scripts of Open Source or closed sourced projects should install the compiled files here in their unstripped form, so other projects can link against them.

./scripts
> Here are the scripts to create update packages that contain a container.

./scripts/build_all.sh
> This script creates all already defined demo containers - it removes all compiled object files, downloads all open source packages, compiles everything and creates all containers.

./scripts/create_container_XXXX.sh
> These scripts do everything to create one specific of the already define demo containers.

./scripts/rootfs_lists
> These list files define which files are copied into a container. They can include further file definitions like the ones of the sub directory "snippets".

./working/<ARCH\>
> The build scripts are working in this volatile directory. The Open Source packets are extracted, configured, maked and installed here. The wanted parts of the project are copied to rootfs_staging. Be aware, that these files get modified by the scripts. Do not edit here!

This repository offers the directory structure and scripts to create new containers with the M3SDK.

Overview of the directories
===========================
./closed_packages
> A place where customers applications are sourced that are not Open Source.

./doc
> Help texts, FAQs and links to further help.

./images
> Final container images get packed and stored here in form of update packages.

./oss_packages
> Open Source projects and their build script are located here.

./oss_packages/dl
> The sources of packages to be build have to be downloaded and stored here.

./oss_packages/scripts
> The source of the Open Source projects can be build with these scripts.

./oss_packages/scripts/helpers
> Helping scripts for the build scripts above are located here.

./oss_packages/src
> In case the project to be build has to be modified with patches or own modifications, the
modified files are stored here. These files replace the files of the original project before it gets build.

./rootfs_skeleton
> Files stored here are copied to the containers root file system when they are mentioned in a rootfs_list.txt file.

./rootfs_staging
> Build scripts of Open Source or closed sourced projects should install the compiled files here in their unstripped form, so other projects can link against them.

./scripts
> Here are the scripts to create update packages that contain a container.

./scripts/mk_all.sh
> This script compiles removes all compiled object files, all downloaded open source packages and all created containers. Afterwards it runs every build script in oss_packages/scripts and creates every container for which a script exists.

./scripts/keys
> Here are public and private RSA keys used to optionally encrypt containers.

./scripts/rootfs_lists
> These lists contain which files from /rootfs_skeleton are copied into a container. They define the content of a root file system of a container.

./working
> The build scripts are working in this volatile directory. The Open Source packets are extracted, configured, maked and installed here. The wanted parts of the project are copied to rootfs_staging.

./working/rootfs_target
> This directory contains the rootfs of the container, that has finally been created and is used to package. This directory gets removed and created freshly when invoking "mk_container.sh" script.

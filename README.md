This repository offers the directory structure and scripts to create new containers.

Overview of the directories
===========================
./closed_packages
> A place where customers applications are sourced that are not to be Open Source.

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
modified files are stored here. These files replace the files of the original project before it
gets build.

./rootfs_skeleton
> The base files of a containers rootfs are stored here. These files always get copied in a final
container.

./rootfs_staging
> Build scripts of Open Source or closed sourced projects should install the compiled files here in
their unstripped form, so other projects can link against them.

./scripts
> Here are the genereic scripts to create complete containers.

./scripts/helpers
> These scripts are moste usually only used by the generic scripts above.

./working
> The build scripts are working in this volatile directory. The Open Source packets are extracted,
configured, maked and installed here. The wanted parts of the project are copied to rootfs_staging.

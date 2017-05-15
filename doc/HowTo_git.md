# Container Application "git"

## Introduction
"Git is a free and open source distributed version control system designed to handle everything from small to very large projects with speed and efficiency." ([cited from https://git-scm.com](https://git-scm.com/)). 

This document will describe how to install a git repository within a container. The repository can be access via no authentication at all or via SSH.

## Install and configure a container with git
Upload and configure the [git container](https://m3-container.net/M3_Container/images/container_git.tar) on your router. Bridge the container to an IP net that has access to the internet. Enter the container as root and set prepare everything for a new repository.

First of all change the password of root:
<pre>
root@container_git ~  $ <b>passwd</b>
</pre>

Then create a new user named "user" and enter a password:
<pre>
root@container_git ~  $ <b>adduser -G users user</b>
</pre>

Let the user have access to /dev/null:
<pre>
root@container_git ~  $ <b>chmod 666 /dev/null</b>
</pre>

## Install a new repository
From this point on it's not necessary to have root permissions any more. Log out and log in as "user" or become user with su:
<pre>
root@container_git ~  $ <b>su user</b>
</pre>

Create a new directory where the new repository should exist:
<pre>
root@container_git ~  $ <b>mkdir ~/repo</b>
root@container_git ~  $ <b>cd ~/repo</b>
</pre>

Configure the users name an E-Mail address of this master repository:
<pre>
root@container_git ~  $ <b>git config --global user.email "you@example.com"</b>
root@container_git ~  $ <b>git config --global user.name "Your Name"</b>
</pre>

Create the repository itself. It will be a bare repo without any files. This directory will only hold the repository database, no source files. The sources will be created on other machines, after they clone this repo.
<pre>
root@container_git ~  $ <b>git init --bare</b>
</pre>

Optionally start the git daemon, so that other users on other machines can clone this repository without any authentication. This is only recommended for friendly LANs. Do <b>NOT</b> use this when you want to avoid that the whole mankind can modify your repository:
<pre>
root@container_git ~  $ <b>git daemon --reuseaddr --base-path=/home/user --export-all --enable=receive-pack --verbose</b>
</pre>

In case this git daemon should be started automatically after the container starts, append this line in finit.conf:
<pre>
service /bin/git daemon --reuseaddr --base-path=/home/user --export-all --enable=receive-pack
</pre>

## Use the repository without authentication
On another machine (most likely your PC) the repository can be cloned. It is assumed that the containers IP address is 192.168.1.3:
<pre>
joe@pc ~  $ <b>git clone git://192.168.1.3/repo</b>
</pre>

Enter the fresh repository and create a file there:
<pre>
joe@pc ~  $ <b>cd repo</b>
joe@pc ~  $ <b>echo "This is the first file of the repository" > first_file.txt</b>
</pre>

Add the new file to the repo and push it to the bare repo within the container:
<pre>
joe@pc ~  $ <b>git add first_file.txt</b>
joe@pc ~  $ <b>git commit -am "first_file.txt has been added</b>
joe@pc ~  $ <b>git push</b>
</pre>

## Use the repository via SSH
On another machine (most likely your PC) the repository can be cloned. It is assumed that the containers IP address is 192.168.1.3:
<pre>
joe@pc ~  $ <b>git clone ssh://user@192.168.1.3:/home/user/repo</b>
</pre>

Enter the fresh repository and create a file there:
<pre>
joe@pc ~  $ <b>cd repo</b>
joe@pc ~  $ <b>echo "This is the first file of the repository" > first_file.txt</b>
</pre>

Add the new file to the repo and push it to the bare repo within the container:
<pre>
joe@pc ~  $ <b>git add first_file.txt</b>
joe@pc ~  $ <b>git commit -am "first_file.txt has been added</b>
joe@pc ~  $ <b>git push</b>
</pre>

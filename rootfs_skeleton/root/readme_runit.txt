=================================
          First steps
=================================
This container can be seen as a complete machine with own net interfaces, users and groups.

Please change the default password!
===================================
Make it a difficult and long one to avoid that this container gets used as a slave of a bot net or worse. Type:
    $ passwd

Optonally modify networking
===================================
The containers net configuration (gateway and DNS) can be modified manually:
    $ vi /bin/start_net.sh

Get more info
===================================
Use the online help of this router! Use your browser and navigate to the menu "Help" -> "Documentation"

Add a non-root user
===================================
It is strongly recommended _NOT_ to work as root unless it's absolutely necessary. Create a new user:
    $ adduser -G users user

Start your application
===================================
In case you want your application to start automatically whenever the container starts, you have to make your application a service
1. Add a directory in /var/service with the name of your application service
2. Add a run script in /var/service/<your service name> with name run

If you don't know the syntax of run script look into /var/service/lighttpd

Use SSH keys instead of a password
===================================
Store your public SSH key to log in without the previously created difficult and long password.
    $ vi /root/.ssh/authorized_keys

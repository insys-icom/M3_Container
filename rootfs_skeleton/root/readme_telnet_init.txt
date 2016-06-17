=================================
          First steps
=================================
This container can be seen as a complete machine with one net interface and its own users and groups.

Please change the default password!
===================================
Make it a difficult and long one to avoid that this container gets used as a slave of a bot net or worse. Type:
    # passwd


Set up networking
===================================
This container has one ethernet interface which is bridged to one of the routers IP nets. The interface got already an IP address. It still lacks a default route and a DNS server address. To let the configure this permanently edit the net startup script
    # vi /bin/start_net.sh


Configure a DNS server address
===================================
Most of the time the router will be the DNS server as well:
    # vi /etc/resolv.conf


Get more info
===================================
Read about the special directories and files of this container in the online help of this router. Use your browser and navigate to the menu Help -> Documentation -> Language icon -> Container


Add a non-root user
===================================
Despite being within a container it is strongly recommended not to login as root whenever possible. Create a new user:
    # adduser -G users user


Start your application
===================================
In case you want your application to start automatically whenever the container starts, edit the config file of the init service:
    # vi /etc/finit.conf
Start the line with the key word "service".
Optionally append the user, that rights and capabilities should be used for this application, e.g. "user".
Append the full path to the application and their parameters. Please notice, that the application is not allowed to daemonise itself. Otherwise finit will restart the service immediatelly, because it regards the application has exited. A line would look like
    service user /bin/application


Use SSH keys instead of a password
===================================
Store your public SSH key to log in without the previously created difficult and long password.
    # vi /root/.ssh/authorized_keys

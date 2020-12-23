These recommendations should help to improve the quality of your developed container:

* Look after RAM
    ** look out for memory leaks (use free, top, cat /proc/meminfo)
    ** evaluate if huge applications are apropriate
    ** ensure to close file descriptors (check in /proc/<PID>/fd)
* Look after flash memory
    ** keep a container as small as possible
    ** avoid writing to flash whenever possible, because amount of writes is limited regarding lifetime of flash, use TMPFS, Redis-DB
    ** rotate and archive files that grow constantly, e.g. log files
* Look after CPU
    ** check with top, time, uptime
* Avoid / minimize dependencies to third party software
    ** use tested libraries for crypto, avoid implement that on your own
    ** use libraries that size and dependencies match your needs
* Respect licences of third party software
    ** separate open source from closed source software
    ** mention used licence
    ** live the idea of open source, publish modifications/bug fixes of open source software
* Keep third party software up to date
    ** look out for bug fixes, security and feature update of used third party software
* Look after security
    ** treat a container like a pysically separate machine, otherwise it could be used as a jump host for malware
    ** use strong authentication for all services, use certificates or keys when possible
    ** do not start unnecessary services
    ** use net filter also for communication with services within the container
    ** do not implement hidden back doors
* Look after reproducibility of binaries and containers
    ** automate builds e.g. with Makefiles or scripts
    ** use repositories
    ** use a separate instance of M3_Container for every projet to avoid dependencies
* Test early and in parallel to development
    ** ensure to be able to update the container
    ** watch the behaviour in endurance tests

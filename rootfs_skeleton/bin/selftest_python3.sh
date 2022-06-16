#!/bin/sh
. /etc/profile

# print a small python script using SSL
echo -en "
#!/bin/python
try:
    import ssl
except:
    if ssl.RAND_status() == 1:
        exit(0)
    else:
        exit(1)
" > /tmp/selftest_python.py

/bin/python /tmp/selftest_python.py
exit $?

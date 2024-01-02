#!/bin/sh
. /etc/profile

# print a small python script using SSL
echo -en "
#!/bin/python
import ssl
" > /tmp/selftest_python.py

/bin/python /tmp/selftest_python.py
[ "$?" == 0 ] && echo "Python selftest script successful!"
exit $?

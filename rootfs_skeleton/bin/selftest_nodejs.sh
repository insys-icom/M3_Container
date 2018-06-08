#!/bin/sh
. /etc/profile

# print a small script
echo -en "
var http = require('http');

http.createServer(function (req, res) {
    res.writeHead(200, {'Content-Type': 'text/plain'});
    res.end('Hello World!');
}).listen(80);
" > /tmp/webserver.js

# run the webserver
/bin/node /tmp/webserver.js &

# retrive http index site
cd /tmp
rm -Rf index.html
wget "http://[::1]"
[ $? != 0 ] && exit 1

# kill the webserver
killall node

# look for "Hello" within index site
cat index.html | grep "Hello"
exit $?

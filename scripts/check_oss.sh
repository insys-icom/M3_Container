#/bin/sh

# use wget to check for an updated packet
wget_check() {
    wget "$2" -q -O - | grep -qzoP "$3"
    [ "$?" != 0 ] && echo -en "$1: new version available on $2\n"
}

# wget_check <URL to check> <text to parse in the retrieved HTML>  <additional wget parameter>
wget_check "libxcrypt"  "https://github.com/besser82/libxcrypt"                 ">v4.5.2</span>"
wget_check "lz4"        "https://github.com/lz4/lz4"                            ">LZ4 v1.10.0"
wget_check "openssl"    "https://www.openssl.org/source"                        "openssl-3.6.0.tar.gz"
wget_check "pcre2"      "https://github.com/PhilipHazel/pcre2"                  ">PCRE2 10.47</span>"
wget_check "timezone"   "https://www.iana.org/time-zones"                       "Released 2025-12-10"
wget_check "zlib"       "https://www.zlib.net"                                  "zlib 1.3"
wget_check "busybox"    "https://busybox.net"                                   "</li>\n\n  <li><b>19 May 2023 -- BusyBox 1.36.1"
wget_check "metalog"    "https://github.com/hvisage/metalog"                    ">metalog-20230719</span>"
wget_check "dropbear"   "https://matt.ucc.asn.au/dropbear/dropbear.html"        "Latest is 2025.89"
wget_check "dnsmasq"    "https://www.thekelleys.org.uk/dnsmasq"                 "LATEST_IS_2.91"
wget_check "sqlite-src" "https://www.sqlite.org/download.html"                  "sqlite-src-3510100.zip"
wget_check "cacert"     "https://curl.se/docs/caextract.html"                   "Tue Dec 2 04:12:02 2025 GMT"
wget_check "libuuid"    "http://sourceforge.net/projects/libuuid/files"         "libuuid-1.0.3.tar.gz \(318.3 kB\)"
wget_check "expat"      "https://github.com/libexpat/libexpat"                  '2.7.3</span>\n        <span title="Label: Latest"'
wget_check "c-ares"     "https://github.com/c-ares/c-ares"                      "1.34.6</span>"
wget_check "libffi"     "https://github.com/libffi/libffi"                      "v3.5.0"
wget_check "xz"         "https://tukaani.org/xz"                                "5.8.2 \(2025-12-17\)"
wget_check "python"     "https://docs.python.org/3"                             "Python 3.14.2 documentation"
wget_check "pyserial"   "https://pypi.org/project/pyserial/#files"              "pyserial-3.5.tar.gz"
wget_check "pymodbus"   "https://github.com/pymodbus-dev/pymodbus"              "Pymodbus v3.11.4</span>"
wget_check "nghttp2"    "https://github.com/nghttp2/nghttp2"                    "nghttp2 v1.68.0"
wget_check "libssh2"    "https://github.com/libssh2/libssh2"                    "libssh2-1.11.1"
wget_check "curl"       "https://curl.haxx.se/download.html"                    "<b>curl 8.17.0</b>, Released on"
wget_check "nano"       "https://www.nano-editor.org/download.php"              "nano-8.7.tar.xz"
wget_check "node"       "https://nodejs.org/en/download/prebuilt-binaries"      "Download Node.js v22.21.1"
wget_check "ncurses"    "https://invisible-island.net/ncurses/announce.html"    "6.5, released"
wget_check "jansson"    "https://github.com/akheron/jansson"                    "v2.14.1</span>"
wget_check "apr"        "https://apr.apache.org"                                "APR 1.7.6, released"
wget_check "apr-util"   "https://apr.apache.org"                                "APR-util 1.6.3, released"
wget_check "httpd"      "https://httpd.apache.org"                              "Apache httpd 2.4.66 Released"
wget_check "php"        "https://www.php.net/downloads.php?source=Y"            "Current Stable</span>\n            PHP 8.5.0"
wget_check "nmap"       "https://nmap.org/dist"                                 "The latest Nmap release is version 7.98"
wget_check "openvpn"    "https://github.com/OpenVPN/openvpn"                    ">v2.6.17</span>"
wget_check "libcap-ng"  "https://people.redhat.com/sgrubb/libcap-ng"            "Latest Release is 0.8.5"
wget_check "libpcap"    "https://www.tcpdump.org/index.html#latest-releases"    ">libpcap-1.10.5.tar.xz</a>"
wget_check "tcpdump"    "https://www.tcpdump.org/index.html#latest-releases"    ">tcpdump-4.99.5.tar.xz</a>"
wget_check "stunnel"    "https://www.stunnel.org/downloads.html"                "stunnel-5.76.tar.gz"
wget_check "iptables"   "https://git.netfilter.org/iptables"                    "Age</th></tr>\n<tr><td><a href=\'/iptables/tag/\?h=v1.8.11\'>v1.8.11"
wget_check "cJSON"      "https://github.com/DaveGamble/cJSON"                   "1.7.19</span>"
wget_check "mosquitto"  "https://mosquitto.org/download"                        "mosquitto-2.0.22.tar.gz"
wget_check "charset"    "https://github.com/jawah/charset_normalizer"           "Version 3.4.4"
wget_check "idna"       "https://github.com/kjd/idna"                           ">v3.11</span>"
wget_check "requests"   "https://pypi.org/project/requests/"                    "requests 2.32.5</h1>"
wget_check "urllib3"    "https://pypi.org/project/urllib3/"                     "urllib3 2.6.2</h1>"
wget_check "socat"      "http://www.dest-unreach.org/socat"                     "version 1.8.0.0</a> has been released"
wget_check "bftpd"      "https://sourceforge.net/projects/bftpd/files/bftpd"    "bftpd-6.3.tar.gz \(180.6 kB\)"
wget_check "rsync"      "https://download.samba.org/pub/rsync/src"              "rsync-3.4.1" ""
wget_check "libevent"   "https://github.com/libevent/libevent"                  "release-2.1.12-stable"
wget_check "addrwatch"  "https://github.com/fln/addrwatch"                      "addrwatch v1.0.2"
wget_check "lua"        "https://lua.org/download.html"                         "lua-5.4.8"

# not needed any more, use ensurepip that comes with python:
# wget_check "get-pip"    "https://pip.pypa.io/en/stable/news"                    "pip documentation v22.2.2"

# not needed any more, is included in busybox:
# wget_check "bzip2"      "https://www.sourceware.org/bzip2"                      "is bzip2 1.0.8"

# a quite complicated search string:
# wget_check "screen"     "https://ftp.gnu.org/gnu/screen"                        "screen-4.9.0.tar.gz.sig</a></td><td align=\"right\">2022-02-01 11:01  </td><td align=\"right\">659 </td><td>&nbsp;</td></tr>\n   <tr><th"

# iperf doesn't make releases, sets only tags
# wget_check "iperf"      "https://github.com/esnet/iperf/tags"

# wget_check "json-c"     "http://json-c.github.io/json-c/"                      '<a href="json-c-current-release/doc/html/index.html">json-c-0.16'

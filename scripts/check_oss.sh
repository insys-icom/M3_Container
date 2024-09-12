#/bin/sh

# use wget to check for an updated packet
wget_check() {
    wget "$2" "$4" -q -O - | grep -qzoP "$3"
    [ "$?" != 0 ] && echo -en "$1: new version available on $2\n"
}

# wget_check <URL to check> <text to parse in the retrieved HTML>  <additional wget parameter>
wget_check "lz4"        "https://github.com/lz4/lz4"                            ">LZ4 v1.10.0</span>" ""
wget_check "openssl"    "https://www.openssl.org/source"                        "openssl-3.3.1.tar.gz" ""
wget_check "pcre2"      "https://github.com/PhilipHazel/pcre2"                  ">PCRE2-10.44</span>" ""
wget_check "timezone"   "https://www.iana.org/time-zones"                       "Released 2024-02-01" ""
wget_check "zlib"       "https://www.zlib.net"                                  "zlib 1.3" ""
wget_check "busybox"    "https://busybox.net"                                   "</li>\n\n  <li><b>19 May 2023 -- BusyBox 1.36.1" ""
wget_check "Linux-PAM"  "https://github.com/linux-pam/linux-pam"                "Linux-PAM 1.6.1" ""
wget_check "metalog"    "https://github.com/hvisage/metalog"                    ">metalog-20230719</span>" ""
wget_check "dropbear"   "https://matt.ucc.asn.au/dropbear/dropbear.html"        "Latest is 2024.85" ""
wget_check "dnsmasq"    "https://www.thekelleys.org.uk/dnsmasq"                 "LATEST_IS_2.90" ""
wget_check "sqlite-src" "https://www.sqlite.org/download.html"                  "sqlite-src-3460000.zip" ""
wget_check "cacert"     "https://curl.se/docs/caextract.html"                   "Tue Jul 2 03:12:04 2024 GMT" ""
wget_check "libuuid"    "http://sourceforge.net/projects/libuuid/files"         "libuuid-1.0.3.tar.gz \(318.3 kB\)" ""
wget_check "expat"      "https://github.com/libexpat/libexpat"                  '2.6.2</span>\n        <span title="Label: Latest"' ""
wget_check "c-ares"     "https://github.com/c-ares/c-ares"                      "1.32.2</span>" ""
wget_check "libffi"     "https://github.com/libffi/libffi"                      "v3.4.6" ""
wget_check "xz"         "https://tukaani.org/xz"                                "5.6.2 were released on 2024-05-29" ""
wget_check "python"     "https://docs.python.org/3"                             "Python 3.12.4 documentation" ""
wget_check "pyserial"   "https://pypi.org/project/pyserial/#files"              "pyserial-3.5.tar.gz" ""
wget_check "pymodbus"   "https://pypi.org/project/pymodbus/#files"              "pymodbus-3.6.9.tar.gz" ""
wget_check "nghttp2"    "https://github.com/nghttp2/nghttp2"                    "nghttp2 v1.62.1" ""
wget_check "libssh2"    "https://github.com/libssh2/libssh2"                    "libssh2-1.11.0" ""
wget_check "curl"       "https://curl.haxx.se/download.html"                    "<b>curl 8.8.0</b>, Released on" ""
wget_check "nano"       "https://www.nano-editor.org/download.php"              "nano-8.1.tar.xz" ""
wget_check "node"       "https://nodejs.org/en/download/prebuilt-binaries"      "Download Node.js v20.15.1" ""
wget_check "ncurses"    "https://invisible-island.net/ncurses/announce.html"    "<span class=\"main-name\">ncurses</span> 6.5, released" ""
wget_check "jansson"    "https://github.com/akheron/jansson"                    "v2.14</span>" ""
wget_check "apr"        "https://apr.apache.org"                                "APR 1.7.4, released" ""
wget_check "apr-util"   "https://apr.apache.org"                                "APR-util 1.6.3, released" ""
wget_check "httpd"      "https://httpd.apache.org"                              "Apache httpd 2.4.61 Released" ""
wget_check "php"        "https://www.php.net/downloads"                         "Current Stable</span>\n    PHP 8.3.9" ""
wget_check "nmap"       "https://nmap.org/dist"                                 "The latest Nmap release is version 7.95" ""
wget_check "openvpn"    "https://fossies.org/linux/openvpn/ChangeLog"           "openvpn-2.6.11/ChangeLog" ""
wget_check "libcap-ng"  "https://people.redhat.com/sgrubb/libcap-ng"            "Latest Release is 0.8.5" ""
wget_check "libpcap"    "https://www.tcpdump.org/index.html#latest-releases"    ">libpcap-1.10.4.tar.xz</a>" ""
wget_check "tcpdump"    "https://www.tcpdump.org/index.html#latest-releases"    ">tcpdump-4.99.4.tar.xz</a>" ""
wget_check "stunnel"    "https://www.stunnel.org/downloads.html"                "stunnel-5.72.tar.gz" ""
wget_check "iptables"   "https://git.netfilter.org/iptables"                    "Age</th></tr>\n<tr><td><a href=\'/iptables/tag/\?h=v1.8.10\'>v1.8.10" ""
wget_check "cJSON"      "https://github.com/DaveGamble/cJSON"                   "1.7.18</span>" ""
wget_check "mosquitto"  "https://mosquitto.org/download"                        "mosquitto-2.0.18.tar.gz" ""
wget_check "charset"    "https://pypi.org/project/charset-normalizer"           "charset-normalizer-3.3.2" ""
wget_check "idna"       "https://pypi.org/project/idna"                         "idna-3.7" ""
wget_check "requests"   "https://pypi.org/project/requests"                     "requests-2.32.3" ""
wget_check "urllib3"    "https://pypi.org/project/urllib3"                      "urllib3 2.2.2" ""
wget_check "socat"      "http://www.dest-unreach.org/socat"                     "version 1.8.0.0</a> has been released" ""
wget_check "bftpd"      "https://sourceforge.net/projects/bftpd/files/bftpd"    "bftpd-6.2.tar.gz \(191.9 kB\)" ""

# not needed any more, use ensurepip that comes with python:
# wget_check "get-pip"    "https://pip.pypa.io/en/stable/news"                    "pip documentation v22.2.2" ""

# not needed any more, is included in busybox:
# wget_check "bzip2"      "https://www.sourceware.org/bzip2"                      "is bzip2 1.0.8" ""

# a quite complicated search string:
# wget_check "screen"     "https://ftp.gnu.org/gnu/screen"                        "screen-4.9.0.tar.gz.sig</a></td><td align=\"right\">2022-02-01 11:01  </td><td align=\"right\">659 </td><td>&nbsp;</td></tr>\n   <tr><th" ""

# iperf doesn't make releases, sets only tags
# wget_check "iperf"      "https://github.com/esnet/iperf/tags"  "" ""

# wget_check "json-c"     "http://json-c.github.io/json-c/"                      '<a href="json-c-current-release/doc/html/index.html">json-c-0.16' ""

#/bin/sh

# use wget to check for an updated packet
wget_check() {
    wget "$2" "$4" -q -O - | grep -qzoP "$3"
    [ "$?" != 0 ] && echo -en "$1: new version available on $2\n"
}

# wget_check <URL to check> <text to parse in the retrieved HTML>  <additional wget parameter>
wget_check "lz4"        "https://github.com/lz4/lz4"                            ">LZ4 v1.9.4</span>" ""
wget_check "openssl"    "https://www.openssl.org/source"                        "openssl-3.0.8.tar.gz" ""
wget_check "pcre2"      "https://github.com/PhilipHazel/pcre2"                  ">PCRE2-10.42</span>" ""
wget_check "timezone"   "https://www.iana.org/time-zones"                       "Released 2022-11-29" ""
wget_check "zlib"       "https://www.zlib.net"                                  "zlib 1.2.13" ""
wget_check "busybox"    "https://github.com/meefik/busybox"                     "BusyBox 1.34.1" ""
wget_check "Linux-PAM"  "https://github.com/linux-pam/linux-pam"                "Linux-PAM 1.5.2" ""
wget_check "metalog"    "https://github.com/hvisage/metalog"                    ">metalog-20220214</span>" ""
wget_check "dropbear"   "https://matt.ucc.asn.au/dropbear/dropbear.html"        "Latest is 2022.83" ""
wget_check "dnsmasq"    "https://www.thekelleys.org.uk/dnsmasq"                 "LATEST_IS_2.89" ""
wget_check "sqlite-src" "https://www.sqlite.org/download.html"                  "sqlite-src-3400100.zip" ""
wget_check "cacert"     "https://curl.se/docs/caextract.html"                   "Tue Jan 10 04:12:06 2023 GMT" ""
wget_check "libuuid"    "http://sourceforge.net/projects/libuuid/files"         "libuuid-1.0.3.tar.gz \(318.3 kB\)" ""
wget_check "expat"      "https://github.com/libexpat/libexpat"                  '2.5.0</span>\n        <span title="Label: Latest"' ""
wget_check "c-ares"     "https://github.com/c-ares/c-ares"                      "1.19.0</span>" ""
wget_check "libffi"     "https://github.com/libffi/libffi"                      "v3.4.4" ""
wget_check "xz"         "https://tukaani.org/xz"                                "5.2.6 was released on 2022-08-12." ""
wget_check "python"     "https://www.python.org/downloads"                      ">Download Python 3.11.2</a>" ""
wget_check "pyserial"   "https://pypi.org/project/pyserial/#files"              "pyserial-3.5.tar.gz" ""
wget_check "pymodbus"   "https://pypi.org/project/pymodbus/#files"              "pymodbus-3.1.3.tar.gz" ""
wget_check "nghttp2"    "https://github.com/nghttp2/nghttp2"                    "nghttp2 v1.52.0" ""
wget_check "libssh2"    "https://github.com/libssh2/libssh2"                    "libssh2-1.10.0" ""
wget_check "curl"       "https://curl.haxx.se/download.html"                    "<b>curl 7.88.1</b>, Released on" ""
wget_check "nano"       "https://www.nano-editor.org/download.php"              "nano-7.2.tar.xz" ""
wget_check "node"       "https://nodejs.org/en/download"                        "Latest LTS Version: <strong>18.14.1</strong>" ""
wget_check "ncurses"    "https://invisible-island.net/ncurses/announce.html"    "<span class=\"main-name\">ncurses</span> 6.4, released" ""
wget_check "jansson"    "https://github.com/akheron/jansson"                    "v2.14</span>" ""
wget_check "apr"        "https://apr.apache.org"                                "APR 1.7.0, released" ""
wget_check "apr-util"   "https://apr.apache.org"                                "APR-util 1.6.1, released" ""
wget_check "httpd"      "https://httpd.apache.org"                              "Apache httpd 2.4.55 Released" ""
wget_check "php"        "https://www.php.net/downloads"                         "Current Stable</span>\n    PHP 8.2.3" ""
wget_check "nmap"       "https://nmap.org/dist"                                 "The latest Nmap release is version 7.93" ""
wget_check "openvpn"    "https://fossies.org/linux/openvpn/ChangeLog"           "openvpn-2.6.0/ChangeLog" ""
wget_check "HTTPing"    "https://github.com/folkertvanheusden/HTTPing"          ">v2.9</span>" ""
wget_check "libcap-ng"  "https://people.redhat.com/sgrubb/libcap-ng"            "Latest Release is 0.8.3" ""
wget_check "libpcap"    "https://www.tcpdump.org/index.html#latest-releases"    ">libpcap-1.10.3.tar.gz</a>" ""
wget_check "tcpdump"    "https://www.tcpdump.org/index.html#latest-releases"    ">tcpdump-4.99.3.tar.gz</a>" ""
wget_check "stunnel"    "https://www.stunnel.org/downloads.html"                "stunnel-5.68.tar.gz" ""
wget_check "iptables"   "https://git.netfilter.org/iptables"                    "Age</th></tr>\n<tr><td><a href=\'/iptables/tag/\?h=v1.8.9\'>v1.8.9" ""
wget_check "libcap-ng"  "https://people.redhat.com/sgrubb/libcap-ng"            "Latest Release is 0.8.3" ""
wget_check "cJSON"      "https://github.com/DaveGamble/cJSON"                   "1.7.15</span>" ""
wget_check "mosquitto"  "https://mosquitto.org/download"                        "mosquitto-2.0.15.tar.gz" ""

# not needed any more, use ensurepip that comes with python:
# wget_check "get-pip"    "https://pip.pypa.io/en/stable/news"                    "pip documentation v22.2.2" ""

# not needed any more, is included in busybox:
# wget_check "bzip2"      "https://www.sourceware.org/bzip2"                      "is bzip2 1.0.8" ""

# a quite complicated search string:
# wget_check "screen"     "https://ftp.gnu.org/gnu/screen"                        "screen-4.9.0.tar.gz.sig</a></td><td align=\"right\">2022-02-01 11:01  </td><td align=\"right\">659 </td><td>&nbsp;</td></tr>\n   <tr><th" ""

# iperf doesn't make releases, sets only tags
# wget_check "iperf"      "https://github.com/esnet/iperf/tags"  "" ""

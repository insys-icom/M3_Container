#/bin/sh

# use wget to check for an updated packet
wget_check() {
    wget "$2" -q -O - | grep -qzoP "$3"
    [ "$?" != 0 ] && echo -en "$1: new version available on $2\n"
}

# wget_check <URL to check> <text to parse in the retrieved HTML>  <additional wget parameter>
wget_check "addrwatch"  "https://api.github.com/repos/fln/addrwatch/releases/latest"                      '"tag_name": "v1.0.2"'
wget_check "apr"        "https://apr.apache.org"                                                          "APR 1.7.6, released"
wget_check "apr-util"   "https://apr.apache.org"                                                          "APR-util 1.6.5, released"
wget_check "bftpd"      "https://sourceforge.net/projects/bftpd/files/bftpd"                              "bftpd-6.7.tar.gz \(173.3 kB\)"
wget_check "busybox"    "https://busybox.net"                                                             "</li>\n\n  <li><b>19 May 2023 -- BusyBox 1.36.1"
wget_check "c-ares"     "https://api.github.com/repos/c-ares/c-ares/releases/latest"                      '"tag_name": "v1.34.8"'
wget_check "cacert"     "https://curl.se/docs/caextract.html"                                             "Thu Aug 13 03:12:01 2026 GMT"
wget_check "charset"    "https://api.github.com/repos/jawah/charset_normalizer/releases/latest"           '"tag_name": "3.5.1"'
wget_check "cJSON"      "https://api.github.com/repos/DaveGamble/cJSON/releases/latest"                   '"tag_name": "v1.7.19"'
wget_check "curl"       "https://curl.haxx.se/download.html"                                              "Release date: </td><td> <b><b>2026-06-24"
wget_check "dnsmasq"    "https://www.thekelleys.org.uk/dnsmasq"                                           "LATEST_IS_2.93"
wget_check "dropbear"   "https://matt.ucc.asn.au/dropbear/dropbear.html"                                  "Latest is 2026.94"
wget_check "expat"      "https://api.github.com/repos/libexpat/libexpat/releases/latest"                  '"tag_name": "R_2_8_3"'
wget_check "httpd"      "https://httpd.apache.org"                                                        "Apache httpd 2.4.68 Released"
wget_check "idna"       "https://api.github.com/repos/kjd/idna/releases/latest"                           '"tag_name": "v3.19"'
wget_check "iperf"      "https://api.github.com/repos/esnet/iperf/releases/latest"                        '"tag_name": "3.21"'
wget_check "iptables"   "https://git.netfilter.org/iptables"                                              "Age</th></tr>\n<tr><td><a href=\'/iptables/tag/\?h=v1.8.13\'>v1.8.13"
wget_check "jansson"    "https://api.github.com/repos/akheron/jansson/releases/latest"                    '"tag_name": "v2.15.1"'
wget_check "libcap-ng"  "https://people.redhat.com/sgrubb/libcap-ng"                                      "Latest Release is 0.8.5"
wget_check "libevent"   "https://api.github.com/repos/libevent/libevent/releases/latest"                  '"tag_name": "release-2.1.13-stable"'
wget_check "libffi"     "https://api.github.com/repos/libffi/libffi/releases/latest"                      '"tag_name": "v3.8.0"'
wget_check "libpcap"    "https://www.tcpdump.org/index.html#latest-releases"                              ">libpcap-1.10.6.tar.xz</a>"
wget_check "libssh2"    "https://api.github.com/repos/libssh2/libssh2/releases/latest"                    '"tag_name": "libssh2-1.11.1"'
wget_check "libuuid"    "http://sourceforge.net/projects/libuuid/files"                                   "libuuid-1.0.3.tar.gz \(318.3 kB\)"
wget_check "libxcrypt"  "https://api.github.com/repos/besser82/libxcrypt/releases/latest"                 '"tag_name": "v4.5.2"'
wget_check "lua"        "https://lua.org/download.html"                                                   "lua-5.5.1"
wget_check "metalog"    "https://api.github.com/repos/hvisage/metalog/releases/latest"                    "20260811"
wget_check "mosquitto"  "https://mosquitto.org/download"                                                  "mosquitto-2.1.2.tar.gz"
wget_check "nano"       "https://www.nano-editor.org/download.php"                                        "nano-9.2.tar.xz"
wget_check "ncurses"    "https://invisible-island.net/ncurses/announce.html"                              "6.6, released"
wget_check "nghttp2"    "https://api.github.com/repos/nghttp2/nghttp2/releases/latest"                    '"tag_name": "v1.70.0"'
wget_check "nmap"       "https://nmap.org/dist"                                                           "The latest Nmap release is version 7.99"
wget_check "node"       "https://nodejs.org/en/download/prebuilt-binaries"                                "Download Node.js v22.21.1"
wget_check "openssl"    "https://www.openssl.org/source"                                                  "openssl-3.6.4.sh.tar.gz"
wget_check "openvpn"    "https://api.github.com/repos/OpenVPN/openvpn/releases/latest"                    '"tag_name": "v2.7.6"'
wget_check "paho-mqtt"  "https://api.github.com/repos/eclipse-paho/paho.mqtt.python/releases/latest"      '"tag_name": "v2.1.0"'
wget_check "pcre2"      "https://api.github.com/repos/PhilipHazel/pcre2/releases/latest"                  '"tag_name": "pcre2-10.47"'
wget_check "php"        "https://www.php.net/downloads.php?source=Y"                                       "Current Stable</span>\n            PHP 8.5.10"
wget_check "pymodbus"   "https://api.github.com/repos/pymodbus-dev/pymodbus/releases/latest"              '"tag_name": "v3.15.0"'
wget_check "pyserial"   "https://api.github.com/repos/pyserial/pyserial/releases/latest"                  '"tag_name": "v3.5"'
wget_check "python"     "https://docs.python.org/3"                                                       "Python 3.14.7 documentation"
wget_check "requests"   "https://api.github.com/repos/psf/requests/releases/latest"                       '"tag_name": "v2.34.2"'
wget_check "rsync"      "https://download.samba.org/pub/rsync/src"                                        "rsync-3.4.1" ""
wget_check "socat"      "http://www.dest-unreach.org/socat"                                               "</h3>\n\n<p>2026-06-26"
wget_check "sqlite-src" "https://www.sqlite.org/download.html"                                            "sqlite-src-3530400.zip"
wget_check "stunnel"    "https://www.stunnel.org/downloads.html"                                          "stunnel-5.80.tar.gz"
wget_check "tcpdump"    "https://www.tcpdump.org/index.html#latest-releases"                              ">tcpdump-4.99.6.tar.xz</a>"
wget_check "timezone"   "https://www.iana.org/time-zones"                                                 "Released 2026-07-08"
wget_check "urllib3"    "https://api.github.com/repos/urllib3/urllib3/releases/latest"                    '"tag_name": "2.7.0"'
wget_check "wpa_suppl"  "https://w1.fi//wpa_supplicant/"                                                   "wpa_supplicant-2.12.tar.gz"
wget_check "xz"         "https://tukaani.org/xz"                                                           "5.8.3 \(2026-03-31\)"
wget_check "zlib"       "https://www.zlib.net"                                                             "<B> zlib 1.3.2</B></FONT>"

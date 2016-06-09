#!/bin/bash

PORT="8888"
BASE_DIR="$(dirname ${0})"
BASE_DIR="$(realpath $BASE_DIR)"
PROJECT_DIR="$(realpath $BASE_DIR/..)"
export GITWEB_CONFIG_SYSTEM="${BASE_DIR}/cgi-bin/gitweb.conf"

# create gitweb.conf
echo "our \$git_temp = \"/tmp\";" > "${GITWEB_CONFIG_SYSTEM}"
echo "our \$projectroot = \"$PROJECT_DIR\";" >> "${GITWEB_CONFIG_SYSTEM}"
echo "our @git_base_url_list = qw(git://127.0.0.1 http://git@127.0.0.1);" >> "${GITWEB_CONFIG_SYSTEM}"
echo "\$feature{'blame'}{'default'} = [1];" >> "${GITWEB_CONFIG_SYSTEM}"
echo " " >> "${GITWEB_CONFIG_SYSTEM}"

busybox httpd -p "${PORT}" -h "${BASE_DIR}"

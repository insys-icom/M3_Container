#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="sqlite-src-3270200"

# name of the archive in dl directory (use "none" if empty)
# PKG_DOWNLOAD="https://www.sqlite.org/2019/${PKG_ARCHIVE_FILE}
PKG_ARCHIVE_FILE="${PKG_DIR}.zip"

# download link for the sources to be stored in dl directory (use "none" if empty)
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory (use "none" if empty)
PKG_CHECKSUM="57f557ab7889f035358aab5ee98606a5"



SCRIPTSDIR=$(dirname $0)
HELPERSDIR="${SCRIPTSDIR}/helpers"
TOPDIR=$(realpath ${SCRIPTSDIR}/../..)
. "${TOPDIR}/scripts/common_settings.sh"
. "${HELPERSDIR}/functions.sh"
PKG_ARCHIVE="${DOWNLOADS_DIR}/${PKG_ARCHIVE_FILE}"
PKG_SRC_DIR="${SOURCES_DIR}/${PKG_DIR}"
PKG_BUILD_DIR="${BUILD_DIR}/${PKG_DIR}"
PKG_INSTALL_DIR="${PKG_BUILD_DIR}/install"

# see https://www.sqlite.org/compile.html for an explanation of the flags
# https://www.sqlite.org/limits.html
#SQLITE3_OMIT_FLAGS="-DSQLITE_TEMP_STORE=2 \
#                    -DSQLITE_DEFAULT_CACHE_SIZE=500 \
#                    -DSQLITE_DEFAULT_WAL_AUTOCHECKPOINT=250 \
#                    -DSQLITE_DEFAULT_JOURNAL_SIZE_LIMIT=65536 \
#                    -DSQLITE_MAX_LENGTH=100000 \
#                    -DSQLITE_MAX_COLUMN=32 \
#                    -DSQLITE_MAX_SQL_LENGTH=10000 \
#                    -DSQLITE_MAX_VARIABLE_NUMBER=32 \
#                                                    \
#                    -USQLITE_OMIT_ALTERTABLE \
#                    -DSQLITE_OMIT_ANALYZE \
#                    -USQLITE_OMIT_ATTACH \
#                    -DSQLITE_OMIT_AUTHORIZATION \
#                    -USQLITE_OMIT_AUTOINCREMENT \
#                    -USQLITE_OMIT_AUTOINIT \
#                    -USQLITE_OMIT_AUTOMATIC_INDEX \
#                    -USQLITE_OMIT_AUTORESET \
#                    -USQLITE_OMIT_AUTOVACUUM \
#                    -USQLITE_OMIT_BETWEEN_OPTIMIZATION \
#                    -USQLITE_OMIT_BLOB_LITERAL \
#                    -DSQLITE_OMIT_BTREECOUNT \
#                    -USQLITE_OMIT_BUILTIN_TEST \
#                    -USQLITE_OMIT_CAST \
#                    -DSQLITE_OMIT_CHECK \
#                    -DSQLITE_OMIT_COMPILEOPTION_DIAGS \
#                    -USQLITE_OMIT_COMPLETE \
#                    -USQLITE_OMIT_COMPOUND_SELECT \
#                    -DSQLITE_OMIT_CTE \
#                    -DSQLITE_OMIT_DATETIME_FUNCS \
#                    -DSQLITE_OMIT_DECLTYPE \
#                    -DSQLITE_OMIT_DEPRECATED \
#                    -USQLITE_OMIT_DISKIO \
#                    -USQLITE_OMIT_EXPLAIN \
#                    -USQLITE_OMIT_FLAG_PRAGMAS \
#                    -USQLITE_OMIT_FLOATING_POINT \
#                    -USQLITE_OMIT_FOREIGN_KEY \
#                    -USQLITE_OMIT_GET_TABLE \
#                    -DSQLITE_OMIT_INCRBLOB \
#                    -USQLITE_OMIT_INTEGRITY_CHECK \
#                    -USQLITE_OMIT_LIKE_OPTIMIZATION \
#                    -DSQLITE_OMIT_LOAD_EXTENSION \
#                    -DSQLITE_OMIT_LOCALTIME \
#                    -USQLITE_OMIT_LOOKASIDE \
#                    -USQLITE_OMIT_MEMORYDB \
#                    -USQLITE_OMIT_OR_OPTIMIZATION \
#                    -USQLITE_OMIT_PAGER_PRAGMAS \
#                    -USQLITE_OMIT_PRAGMA \
#                    -DSQLITE_OMIT_PROGRESS_CALLBACK \
#                    -USQLITE_OMIT_QUICKBALANCE \
#                    -DSQLITE_OMIT_REINDEX \
#                    -DSQLITE_OMIT_SCHEMA_PRAGMAS \
#                    -DSQLITE_OMIT_SCHEMA_VERSION_PRAGMAS \
#                    -DSQLITE_OMIT_SHARED_CACHE \
#                    -USQLITE_OMIT_SUBQUERY \
#                    -DSQLITE_OMIT_TCL_VARIABLE \
#                    -USQLITE_OMIT_TEMPDB \
#                    -DSQLITE_OMIT_TRACE \
#                    -DSQLITE_OMIT_TRIGGER \
#                    -DSQLITE_OMIT_TRUNCATE_OPTIMIZATION \
#                    -USQLITE_OMIT_UTF16 \
#                    -USQLITE_OMIT_VACUUM \
#                    -DSQLITE_OMIT_VIEW \
#                    -DSQLITE_OMIT_VIRTUALTABLE \
#                    -USQLITE_OMIT_WAL \
#                    -USQLITE_OMIT_WSD \
#                    -DSQLITE_OMIT_XFER_OPT \
#                    -USQLITE_ZERO_MALLOC \
#                    -USQLITE_ENABLE_API_ARMOR \
#                    -USQLITE_DEBUG \
#"
# API_ARMOR and SQLITE_DEBUG is for development only

configure()
{
    cd "${PKG_BUILD_DIR}"
    ./configure CFLAGS="${M3_CFLAGS} ${SQLITE3_OMIT_FLAGS} -pthread -ldl" \
                LDFLAGS="${M3_LDFLAGS}" \
                --target=${M3_TARGET} \
                --host=${M3_TARGET} \
                --prefix="" \
                --disable-largefile \
                --enable-tempstore \
                --disable-readline \
                --disable-tcl \
                --disable-load-extension || exit_failure "failed to configure ${PKG_DIR}"
}

compile()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"
    make ${M3_MAKEFLAGS} || exit_failure "failed to build ${PKG_DIR}"
    make DESTDIR="${PKG_INSTALL_DIR}" install || exit_failure "failed to install ${PKG_DIR} to ${PKG_INSTALL_DIR}"
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    make DESTDIR="${STAGING_DIR}" install || exit_failure "failed to install ${PKG_DIR} to ${STAGING_DIR}"
}

. ${HELPERSDIR}/call_functions.sh

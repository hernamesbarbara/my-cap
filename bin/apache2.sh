#!/bin/bash

export VERSION=2.2.27

. `dirname $0`/functions.sh

setup /usr/local/apache2/logs/apache-$VERSION
download http://www.apache.org/dist/httpd/httpd-$VERSION.tar.bz2
tar jxf httpd-$VERSION.tar.bz2 || exit $?
cd httpd-$VERSION
export CPPFLAGS="-I/usr/local/include"
export LDFLAGS="-L/usr/local/lib"
export CFLAGS="-DAP_UNSAFE_ERROR_LOG_UNESCAPED"
# Debugging Apache.
#export CFLAGS="-DAP_UNSAFE_ERROR_LOG_UNESCAPED -g"

./configure \
 --prefix=/usr/local/apache2 \
 --with-mpm=prefork \
 --with-included-apr \
 --enable-log-config \
 --enable-authn-file \
 --enable-authz-host \
 --enable-authz-group \
 --enable-authz-user \
 --enable-mods-shared="rewrite info worker proxy deflate headers mod_auth include ssl env mime-magic auth_digest expires perl" || exit $?
# Debugging Apache:
# ./configure \
# --prefix=/usr/local/apache2 \
# --with-mpm=prefork \
# --enable-dav \
# --enable-dav-fs \
# --enable-log-config \
# --enable-authn-file \
# --enable-authz-host \
# --enable-authz-group \
# --enable-authz-user \
# --enable-maingainer-mode \
# --prefix=/usr/local/apache2.d \
# --enable-mods-shared="rewrite info worker proxy deflate mod_auth include ssl env mime-magic auth_digest expires dav dav_fs perl"
make -j3 || exit $?
make install || exit $?
echo Apache $VERSION > /usr/local/apache2/logs/apache-$VERSION

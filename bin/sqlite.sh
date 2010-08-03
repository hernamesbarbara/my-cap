#!/bin/sh

export VERSION=3.7.0

. `dirname $0`/functions.sh

setup /usr/local/include/sqlite.h
download http://sqlite.org/sqlite-$VERSION.tar.gz
build sqlite-$VERSION


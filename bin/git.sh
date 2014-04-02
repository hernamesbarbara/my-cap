#!/bin/bash

export VERSION=1.9.1

. `dirname $0`/functions.sh

if [ -f /usr/local/bin/git ]; then
    if [ `/usr/local/bin/git version | awk '{print $3}'` = "$VERSION" ]; then
        exit
    fi
fi

setup

# Download the Subversion dependencies.
rm -rf git-$VERSION
download https://github.com/git/git/archive/v$VERSION.tar.gz
tar zxf v$VERSION.tar.gz || exit $?
cd git-$VERSION
make prefix=/usr/local all doc info
make prefix=/usr/local install install-doc install-html install-info
cd contrib/subtree
make prefix=/usr/local
make prefix=/usr/local install
make prefix=/usr/local install-doc

#rm -rf git-manpages-$VERSION
#download http://git-core.googlecode.com/files/git-manpages-$VERSION.tar.gz
#sudo tar xzv -C /usr/local/share/man -f git-manpages-$VERSION.tar.gz

#!/bin/bash

. `dirname $0`/functions.sh

mkdir -p ~/.cpan/CPAN
mkdir -p ~/.cpanreporter

if [ $OS = 'Darwin' ]; then
    cp `dirname $0`/../config/cpan/DarwinCPANConfig.pm ~/.cpan/CPAN/MyConfig.pm
    mkdir -p '~/Library/Application Support/.cpan/CPAN'
    cp `dirname $0`/../config/cpan/DarwinCPANConfig.pm '~/Library/Application Support/.cpan/CPAN/MyConfig.pm'
    cp `dirname $0`/../config/cpan/cpanreporter.ini ~/.cpanreporter/config.ini
else
    wget --no-check-certificate -O ~/.cpan/CPAN/MyConfig.pm https://raw.githubusercontent.com/theory/my-cap/master/config/cpan/RedHatCPANConfig.pm
    wget --no-check-certificate -O ~/.cpanreporter/config.ini https://raw.githubusercontent.com/theory/my-cap/master/config/cpan/cpanreporter.ini
fi

# Mac::Carbon currently has a failing test. Delete this section when fixed.
if [ $OS = 'Darwin' ]; then
    if [ ! -e /usr/local/lib/perl5/site_perl/5.10.0/darwin-2level/Mac/Carbon.pm ]; then
        cd /tmp
        curl -O http://www.cpan.org/modules/by-authors/id/CNANDOR/Mac-Carbon-0.77.tar.gz
        tar zxf Mac-Carbon-0.77.tar.gz
        cd Mac-Carbon-0.77
        perl Makefile.PL
        make
        sudo make install
        cd ..
        rm -rf Mac-Carbon-0.77
    fi
fi

/usr/local/bin/cpan Task::CPAN::Reporter

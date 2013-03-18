#!/usr/bin/env bash
apt-get -y update
apt-get -y install build-essential zlib1g-dev libssl-dev libreadline-gplv2-dev lib64readline-gplv2-dev libyaml-dev libxslt-dev libxml2-dev
cd /tmp
wget ftp://ftp.ruby-lang.org/pub/ruby/1.9/$1.tar.gz
tar -xvzf $1.tar.gz
cd $1/
./configure --prefix=/usr/local
make
make install
#!/usr/bin/env bash
yum update
yum install gcc g++ make automake autoconf curl-devel openssl-devel zlib-devel httpd-devel apr-devel apr-util-devel sqlite-devel libtool libxml2 libxslt-devel libxml2-devel readline-devel 
cd /tmp
wget http://pyyaml.org/download/libyaml/yaml-0.1.4.tar.gz
tar xzvf yaml-0.1.4.tar.gz
cd yaml-0.1.4
./configure --prefix=/usr/local
make
make install
cd ..
wget ftp://ftp.ruby-lang.org/pub/ruby/1.9/$1.tar.gz
tar -xvzf $1.tar.gz
cd $1/
./configure --prefix=/usr/local
make
make install
#!/usr/bin/env bash

set -e

cd $EXTERNAL_LIBS_BUILD_ROOT

version="93e9e6"

git clone https://github.com/fuwa0529/android-openssl
wget https://github.com/openssl/openssl/archive/OpenSSL_1_0_2l.tar.gz

cd android-openssl
git checkout $version

tar xfz ../OpenSSL_1_0_2l.tar.gz

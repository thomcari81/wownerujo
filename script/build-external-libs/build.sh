#!/usr/bin/env bash

set -e

script/build-external-libs/prep-toolchain.sh

script/build-external-libs/build-openssl.sh
script/build-external-libs/post-build-openssl.sh

script/build-external-libs/build-boost.sh

script/build-external-libs/build-wownero.sh

script/build-external-libs/collect.sh



#!/bin/bash

set -e

orig_path=$PATH
base_dir=`pwd`
build_root=$EXTERNAL_LIBS_BUILD_ROOT

build_type=release # or debug

archs=(arm arm64 x86 x86_64)

for arch in ${archs[@]}; do
    ldflags=""
    extra_cmake_flags=""
    case ${arch} in
        "arm")
            target_host=arm-linux-androideabi
            ldflags="-march=armv7-a -Wl,--fix-cortex-a8"
            xarch=armv7-a
            sixtyfour=OFF
            extra_cmake_flags="-D NO_AES=true"
            ;;
        "arm64")
            target_host=aarch64-linux-android
            xarch="armv8-a"
            sixtyfour=ON
            ;;
        "x86")
            target_host=i686-linux-android
            xarch="i686"
            sixtyfour=OFF
            ;;
        "x86_64")
            target_host=x86_64-linux-android
            xarch="x86-64"
            sixtyfour=ON
            ;;
        *)
            exit 16
            ;;
    esac

    OUTPUT_DIR=$base_dir/build/$build_type.$arch

    mkdir -p $OUTPUT_DIR
    cd $OUTPUT_DIR

    PATH=$build_root/tool/$arch/$target_host/bin:$build_root/tool/$arch/bin:$PATH \
        CC=clang CXX=clang++ \
        cmake \
        -D ANDROID=true \
        -D ARCH="$xarch" \
        -D BOOST_LIBRARYDIR=$build_root/build/boost/$arch/lib \
        -D BOOST_ROOT=$build_root/build/boost/$arch \
        -D BUILD_64=$sixtyfour \
        -D BUILD_GUI_DEPS=1 \
        -D BUILD_TAG="android" \
        -D BUILD_TESTS=OFF \
        -D CMAKE_BUILD_TYPE=$build_type \
        -D CMAKE_POSITION_INDEPENDENT_CODE:BOOL=true \
        -D FORCE_USE_HEAP=1 \
        -D OPENSSL_CRYPTO_LIBRARY=$build_root/build/openssl/$arch/lib/libcrypto.so \
        -D OPENSSL_INCLUDE_DIR=$build_root/build/openssl/$arch/include \
        -D OPENSSL_ROOT_DIR=$build_root/build/openssl/$arch \
        -D OPENSSL_SSL_LIBRARY=$build_root/build/openssl/$arch/lib/libssl.so \
        -D STATIC=ON \
        $extra_cmake_flags \
        ../..

    make -j wallet_api
    find . -path ./lib -prune -o -name '*.a' -exec cp '{}' lib \;

    TARGET_LIB_DIR=$build_root/build/monero/$arch/lib
    rm -rf $TARGET_LIB_DIR
    mkdir -p $TARGET_LIB_DIR
    cp $OUTPUT_DIR/lib/*.a $TARGET_LIB_DIR

    TARGET_INC_DIR=$build_root/build/monero/include
    rm -rf $TARGET_INC_DIR
    mkdir -p $TARGET_INC_DIR
    cp -a ../../src/wallet/api/wallet2_api.h $TARGET_INC_DIR

    cd $base_dir
done

exit 0

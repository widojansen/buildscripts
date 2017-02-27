#!/bin/bash -e

. ../../path.sh

if [ "$1" == "build" ]; then
	true
elif [ "$1" == "clean" ]; then
	rm -rf _build$dir_suffix
	exit 0
else
	exit 255
fi

mkdir -p _build$dir_suffix
cd _build$dir_suffix

cpu=armv7-a
[[ "$ndk_triple" == "aarch64"* ]] && cpu=armv8-a

prefix="`pwd`/../../../prefix$dir_suffix"
PKG_CONFIG_LIBDIR="$prefix/lib/pkgconfig" \
../configure \
	--target-os=android --enable-cross-compile --cross-prefix=$ndk_triple- \
	--arch=${ndk_triple%%-*} --cpu=$cpu --enable-{jni,mediacodec,gmp,gnutls} \
	--extra-cflags="-I$prefix/include" --extra-ldflags="-L$prefix/lib" \
	--disable-static --enable-shared --enable-version3 \
	--prefix="$prefix" --pkg-config=pkg-config --disable-{debug,doc}

make -j6
make install

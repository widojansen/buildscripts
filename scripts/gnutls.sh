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

PKG_CONFIG_LIBDIR="`pwd`/../../../prefix$dir_suffix/lib/pkgconfig" \
../configure \
	--host=$ndk_triple \
	--enable-static --disable-shared \
	--with-nettle-mini --with-included-{libtasn1,unistring} \
	--disable-{doc,tools,cxx,tests} --without-p11-kit \
	--prefix="`pwd`/../../../prefix$dir_suffix"

make -j6
make install
# fix linking (pkg-config seems to ignore Requires.private)
sed '/^Libs:/ s|$| -lnettle -lhogweed|' -i \
	../../../prefix$dir_suffix/lib/pkgconfig/gnutls.pc

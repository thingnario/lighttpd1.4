#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: ./build_lighttpd.sh tool_chain_path install_path!"
    echo "Example: ./build_lighttpd.sh /usr/local/arm-linux /Desktop/eric/logger/build/moxa-ia240/lighttpd"
    exit
fi

export PATH="$PATH:$1/bin"

tool_chain_path=$1
install_path=$2/../
#ARCH=`echo $1 | awk -F"/" '{print (NF>1)? $NF : $1}'`

# linux architecture 
item=`ls $tool_chain_path/bin | grep gcc`
IFS=' ' read -ra ADDR <<< "$item"
item="${ADDR[0]}"
ARCH=`echo $item | sed -e 's/-gcc.*//g'`

# ======== lighttpd with static build ========
./autogen.sh

export ARCH=$ARCH
if [ "$ARCH" == "" ]; then
	export AR=ar
	export AS=as
	export LD=ld
	export RANLIB=ranlib
	export CC=gcc
	export NM=nm
	LIGHTTPD_STATIC=yes ./configure --prefix=$2 --enable-static=yes --without-bzip2 --without-pcre --disable-ipv6 --with-zlib=$install_path/zlib/lib
else
	export AR=${ARCH}-ar
	export AS=${ARCH}-as
	export LD=${ARCH}-ld
	export RANLIB=${ARCH}-ranlib
	export CC=${ARCH}-gcc
	export NM=${ARCH}-nm
	LIGHTTPD_STATIC=yes ./configure --prefix=$2 --target=${ARCH} --host=${ARCH} --enable-static=yes --without-bzip2 --without-pcre --disable-ipv6 --with-zlib=$install_path/zlib/lib
fi

make clean
make
make install

#!/bin/bash

if [ $# -ne 1 ]; then
    echo $0: usage: cross_compile_library.sh ARCH 
    echo "example: usage: cross_compile_library.sh [ arm-linux | arm-linux-gnueabihf | arm-linux-gnueabi ]"
    exit 1
fi

tool_chain_path=$1
#ARCH=`echo $1 | awk -F"/" '{print (NF>1)? $NF : $1}'`

# linux architecture 
item=`ls $tool_chain_path/bin | grep gcc`
IFS=' ' read -ra ADDR <<< "$item"
item="${ADDR[0]}"
ARCH=`echo $item | sed -e 's/-gcc.*//g'`

# ======== lighttpd with static build ========
export ARCH=$ARCH
export AR=${ARCH}-ar
export AS=${ARCH}-as
export LD=${ARCH}-ld
export RANLIB=${ARCH}-ranlib
export CC=${ARCH}-gcc
export NM=${ARCH}-nm

LIGHTTPD_STATIC=yes ./configure --prefix=$tool_chain_path --target=${ARCH} --host=${ARCH} --enable-static=yes --without-bzip2 --without-pcre --disable-ipv6
make clean
make 
sudo "PATH=$PATH" make install

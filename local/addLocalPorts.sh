#!/bin/sh
#
if [ -z ${NANO_PACKAGE_DIR} ] ; then
	export NANO_PACKAGE_DIR="/usr/src/tools/tools/nanobsd/Pkg/"
fi

[ ! -d ../ports ] && exit 0

for p in ../ports/*/pkg-descr ; do
	port=$(dirname $p)
	cd $port
	make
	make package
	cd -
	cp $port/work/pkg/*.txz ${NANO_PACKAGE_DIR}
done

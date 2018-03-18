#!/bin/sh
#
if [ -z ${NANO_PACKAGE_DIR} ] ; then
	export NANO_PACKAGE_DIR="/usr/src/tools/tools/nanobsd/Pkg/"
fi

[ ! -d ../ports ] && exit 0

echo building...

for port in $LOCAL_PACKAGES ; do
	echo $port
	_p="../ports/$port"
	if [ -d $_p ] ; then
		cd $_p
		make
		make package
		cd -
		cp $_p/work/pkg/${port}*.txz ${NANO_PACKAGE_DIR}
	fi
done

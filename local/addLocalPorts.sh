#!/bin/sh
#
if [ -z ${NANO_PACKAGE_DIR} ] ; then
	export NANO_PACKAGE_DIR="/usr/src/tools/tools/nanobsd/Pkg/"
fi

[ ! -d ../ports ] && exit 0

echo building...

for port in $LOCAL_PACKAGES ; do
	echo $port
	_d="../ports/$port"
	if [ -d $_d ] ; then
		cd $_d
		make
		make package
		cd -
		# Spectro450 should be the latest installed package
		# So it rename to _spectro450..txz
		echo $port | grep spectro450 > /dev/null 2>&1
		if [ $? -eq 0 ] ; then
			_p="$_d/work/pkg/${port}*.txz"	
			cp $_d/work/pkg/${port}*.txz ${NANO_PACKAGE_DIR}/zz$(basename ${_p})
		else
			cp $_d/work/pkg/${port}*.txz ${NANO_PACKAGE_DIR}
		fi
	fi
done

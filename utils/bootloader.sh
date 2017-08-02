#!/bin/sh
#
DISKIMAGE=$1

export LANG=C
printf "Adding bootloader ..."
MD=$(mdconfig -f $DISKIMAGE)
printf "y\ny\n" | fdisk -B  /dev/${MD}  > /dev/null 2>&1
rc=$?
if [ $rc -ne 0 ] ; then
	echo " failed."
	exit $rc
fi
echo "done."

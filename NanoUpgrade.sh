#!/bin/sh
#
# This file is part of the spectro-450 Project.
#
# Copyright (c)2016-2017  Luc Hondareyte <lhondareyte_AT_laposte.net>.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#
# 2. redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in 
#    the documentation and/or other materials provided with the distribution.   
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, 
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED 
# OF THE POSSIBILITY OF # SUCH DAMAGE.
#
export TERM=tinyVT
export PATH="/bin:/sbin:/usr/bin:/usr/sbin"
export TEXTDOMAIN=NanoUpgrade

conf="/etc/spectro-450.conf"
mnt="/media/flashdrive"
device="$1"
case $(uname) in
	'FreeBSD')
		tty="/dev/cuaU0"
		;;
	'Linux')
		tty="/dev/ttyUSB0"
		;;
	*)
		exit 0
		;;
esac

exec > $tty

_clrsrc() {
	printf "\033[E" 
}

_stopapp () {
	[ -x /etc/rc.d/$1 ] && /usr/sbin/service $1 stop
	return $?
}

_startapp () {
	[ -x /etc/rc.d/$1 ] && /usr/sbin/service $1 start
	return $?
}

_print_user () { 
	_clrsrc 
	for m in $i ; do printf "$(gettext -s ${*})\n" ; done
}

_umount () {
	umount $mnt
	if [ $? -ne 0 ] ; then
		_print_user "EjectError" "PressAKey"
		_getchar
		_reboot
	fi
}

_mount () {
	mount -t msdosfs -o ro $device $mnt
	return $?
}

_switch_rw () {
	umount /Applications && mount /Installation
	return $?
}

_switch_ro () {
	umount /Installation 
	if [ $? -ne 0 ] ; then
		_print_user "EjectError" "PressAKey"
		_getchar
		_reboot
	fi
       	mount /Applications
}

_readOne () {
	local oldstty
	oldstty=$(stty -g)
	stty -icanon -echo min 1 time 0
	dd bs=1 count=1 2>/dev/null
	stty "$oldstty"
}

_getchar () {
	_readOne < $tty > /dev/null 2>&1
}

_reset_config ()
{
}

_method () {
	[ -f $conf ] && app=$(cat /etc/spectro-450.conf)
	[ -z $app ]  && _main install || _main upgrade
}	

_main () {
	method=$1
	for p in ${mnt}/*.pkg 
	do
		_p=$($(basename $p) | awk -F"." '{print $1}')
		if [ ! -f ${mnt}/${_p}.md5 ] ; then
			exit 1
		else
			app=$_p	
			break;
		fi
	done
	_stopapp
	_print_user "InstallInProgress" "Wait"
	. ${mnt}/${_p}.md5
	/sbin/md5 -c $MD5 ${mnt}/${_p}.pkg
	if [ $? -ne 0 ] ; then
		_print_user "ChecksumError" "PressAKey"
		_getchar
		return 1
	fi
	tar tzf ${mnt}/${app}.pkg
	if [ $? -ne 0 ] ; then
		_print_user "ReadError" "PressAKey"
		_getchar
		return 1
	fi
	_switch_rw
	cd /Installation
	if [ ! -z "${app}" ] ; then
		rm -rf $app
		_reset_config
	fi
	tar xzf ${mnt}/${app}.pkg
	if [ $? -eq 0 ] ; then
		echo $app > $conf
		_print_user "InstallOk" "PressAKey"
		_getchar
	else
		rm -rf $app
		_print_user "InstallError" "GivingUP"
		_reset_config
		sleep 3
		_reboot
	fi
	_switch_ro
}

_mount
_main
_startapp
_umount

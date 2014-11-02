#!/bin/sh
#
# $Id$


export TERM=tinyVT
export PATH="/bin:/sbin:/usr/bin:/usr/sbin"

mnt="/media/flashdrive"
tty="/dev/cuaU0"
device="$1"

if [ -f /usr/share/nanobsd/nano_upgrade.msg ] ; then
	. /usr/share/nanobsd/nano_upgrade.msg
fi

_startapp ()
{
	a=$1
	sleep 3
	if [ -x /etc/rc.d/$a ] ; then
		/usr/sbin/service $a start
	fi
	exit 0
}

_print_vt () 
{ 
	printf "E" > $tty 
	printf "${*}" > $tty 
}

_askuser () {
	tinyvt "$*" "$YES_NO" < $tty > $tty
	r=$?
	printf "c" > $tty
	return $r
}

_runscript () {
	s=/Upgrade/$1
	r=0
	if [ -f $s ] ;  then
		chmod +x $s
		$s
		r=$?
		rm -f $s
	fi
	return $r
}

_pkg () {
	m=$1	# mode d'installation
	a=$2	# nom de l'application
	rc=0
	f=$(echo $a | cut -c1 | tr [a-z] [A-Z] )
	d=$(echo $a | cut -c2- )
	d="${f}${d}"

	echo "Install mode : $m"
	echo "Application  : $a"
	echo "Directory    : $d"

	cd /Upgrade
	if [ -d $d -a $m == "-update" ] ; then
		echo "Sauvegarde de l'ancienne version"
		mv ${d} ${d}.sav
	fi
	_runscript preexec.sh && tar xzf ${mnt}/${a}.pkg && _runscript postexec.sh
	if [ $? -ne 0 ] ; then
		if [ -d ${d}.sav ] ; then
			rm -rf ${d}
			mv ${d}.sav ${d}
		fi

		rc=1
	else
		if [ -d ${d}.sav ] ; then
			rm -rf ${d}.sav 
		fi
	fi
	cd
	return $rc
}

#
# Montage de la clef USB
mount -t msdosfs -o ro $device $mnt
[ $? -ne 0 ]  && exit 0

#
# Controle si une application est deja présente
for d in /Applications/*
do
	if [ -d ${d}/Contents ] ; then
		dirapp=$(basename ${d})
		app=$(basename ${d} | tr [A-Z] [a-z])
	fi
done

#
# En mode install par defaut
mode=install
FAILED_MSG="$INSTALL_FAILED"
SUCCESS_MSG="$INSTALL_SUCCESS"
CONFIRM_MSG="$INSTALL_CONFIRM"
CANCELED_MSG="$INSTALL_CANCELED"
WAIT_MSG="$INSTALL_WAIT"
#
# Si nanobsd vierge, on cherche des packages sont presents sur la clef USB
if [ -z "${app}" ] ; then
	for p in ${mnt}/*.pkg
	do
		_p=$($(basename $p) | awk -F"." '{print $1}')
		if [ -f ${mnt}/${_p}.md5 ] ; then
			. ${mnt}/${_p}.md5
			/sbin/md5 -c $MD5 ${mnt}/${_p}.pkg
			if [ $? -eq 0 ] ; then
				app=$_p		 
				break;
			fi
		fi
	done
	if [ -z "${app}" ] ; then
		cd
		umount $mnt
		exit 0
	fi
elif [ -f ${mnt}/${app}.pkg -a  -f ${mnt}/${app}.md5 ] ; then
	. ${mnt}/${app}.md5
	/sbin/md5 -c $MD5 ${mnt}/${app}.pkg 
	if [ $? -ne 0 ] ; then
		umount $mnt
		exit 0
	fi
elif [ -f ${mnt}/${app}.upd -a  -f ${mnt}/${app}.md5 ] ; then
	. ${mnt}/${app}.md5
	/sbin/md5 -c $MD5 ${mnt}/${app}.app 
	if [ $? -ne 0 ] ; then
		umount $mnt
		exit 0
	fi
	FAILED_MSG="$UPDATE_FAILED"
	SUCCESS_MSG="$UPDATE_SUCCESS"
	CONFIRM_MSG="$UPDATE_CONFIRM"
	CANCELED_MSG="$UPDATE_CANCELED"
	WAIT_MSG="$UPDATE_WAIT"
	mode=update
else
	umount $mnt
	exit 0
fi


#
# Stopping Application ...
if [ -x /etc/rc.d/$app ] ; then
	/usr/sbin/service ${app} stop 
	printf "0" > $tty
fi

_askuser $CONFIRM_MSG
if [ $? -ne 0 ] ; then
	_print_vt "$CANCELED_MSG"
	umount $mnt
	sleep 2 ;  
	/usr/sbin/service $app start
	exit 0
fi
_print_vt "$WAIT_MSG"

#
# Demontage de /Applications read-only
umount /Applications
if [ $? -ne 0 ] ; then
	_print_vt "$UMOUNT_FAILED"
	_startapp $app
fi
mount /Upgrade
if [ $? -ne 0 ] ; then
	_print_vt "$MOUNT_FAILED"
	mount /Applications
	_startapp $app
fi

case mode in 
	'update')
		_pkg -update $app
		r=$?
		;;
	*)
		_pkg -install $app
		r=$?
		;;
esac
umount $mnt
umount /Upgrade
mount /Applications
if [ $r -ne 0 ] ; then
	_print_vt "$FAILED_MSG"
else
	_print_vt "$SUCCESS_MSG"
fi
fin:
sleep 3
if [ -x /etc/rc.d/$app ] ; then
	/usr/sbin/service $app start
fi

_startapp $app

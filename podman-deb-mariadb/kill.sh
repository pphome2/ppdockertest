#!/bin/sh

f="process.txt"
n=`pwd | awk 'BEGIN {FS="/"};{printf $NF }'`
p=`sudo podman ps | grep "$n" | awk 'BEGIN {FS=" "};{print $1}'`

if test -f "$f"; then
	if [ -s $f ] ; then
		if [ ! -z "$p" ]; then
			sudo podman kill $p
		fi
	else
		p=`cat $f`
		if [ ! -z "$p" ]; then
			sudo podman kill $p
		fi
	fi
	rm $f
else
	if [ ! -z "$p" ]; then
		sudo podman kill $p
	fi
fi

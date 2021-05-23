#!/bin/bash

www="/home/peter/public_html"
#www=$(pwd)/www

f="process.txt"

n=`pwd | awk 'BEGIN {FS="/"};{printf $NF }'`
p=`sudo podman ps | grep "$n" | awk 'BEGIN {FS=" "};{print $1}'`

if [ ! -z "$p" ]; then
	echo Már fut.
else
	if [ -d $(pwd)/log ]; then
		rm $(pwd)/log/*
		echo Log ok.
	else
		mkdir $(pwd)/log
		chmod 777 $(pwd)/log
		echo Log ok.
	fi
	if [ -d /var/log/apache2 ]; then
		rm /var/log/apache2/*
		rmdir /var/log/apache2
	else
		if [ -f /var/log/apache2 ]; then
			rm /var/log/apache2
		fi
	fi
	ln -s $(pwd)/log /var/log/apache2
	echo Log2 ok.
	if [ -d $www ]; then
		echo WWW ok.
	else
		mkdir $www
		chmod 777 $www
		echo WWW ok.
	fi
	if [ -d /var/www ]; then
		echo WWW2 ok.
	else
		mkdir /var/www
		echo WWW2 ok.
	fi
	if [ -f /var/www/html ]; then
		rm /var/www/html
	fi
	ln -s $www /var/www/html
	sudo podman run --name "$n" -p 80:80 -p 443:443 \
			--mount type=bind,source=$www,target=/var/www/html \
			--mount type=bind,source=$(pwd)/log,target=/var/log/apache2 \
			$n &
	sleep 5
	c=`sudo podman ps | grep "$n" | awk 'BEGIN {FS=" "};{print $1}'`
	if [ ! -z "$c" ]; then
		echo $c >$f
	else
		echo Nem indult el.
	fi
fi

#
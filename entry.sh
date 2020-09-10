#!/bin/sh

set -e 

error() {
	echo "$@"
	exit 1
}

[[ $$ == "1" ]] || error "This script must be run as the image entry point. Current pid=$$"

# Starts Apache, unless --disable-apache
httpd -k start

# Run FPM via exec. 
exec /usr/local/sbin/php-fpm "$@"

#!/bin/sh

set -e 

error() {
	echo "$@"
	exit 1
}

[[ $$ == "1" ]] || error "This script must be run as the image entry point. Current pid=$$"

# Updates ownership for volumes mounted inside the web root
chown -R apache:apache /var/www/app

# TODO add a user matching the user id on the host. Then run apache and FPM with the newly created user.


# Starts Apache, unless --disable-apache
httpd -k start

# Run FPM via exec. 
exec /usr/local/sbin/php-fpm "$@"

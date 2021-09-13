#!/bin/sh

# Exit immediately if a command exits with a non-zero status.
set -o errexit

error() {
	echo "$@"
	exit 1
}

[[ $$ == "1" ]] || error "This script must be run as the image entry point. Current pid=$$"


# The container needs an IPv6 address, name servers and domain (.tcloud). See dhcpcd.conf to configure request options.

# TODO actually dhcpcd should be sent to the backend so that addresses are renewer when expired.
#  Hooks can be used to send the new address to HAProxy.
dhcpcd --debug --oneshot --waitip=6 --ipv6only --dumplease --persistent eth1



# Updates ownership for volumes mounted inside the web root
chown -R apache:apache /var/www/app

# Starts Apache
httpd -k start

# Run FPM via exec. 
exec /usr/local/sbin/php-fpm "$@"

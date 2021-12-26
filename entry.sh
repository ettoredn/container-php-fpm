#!/bin/sh

set -e 

error() {
	echo "$@"
	exit 1
}

[[ $$ == "1" ]] || error "This script must be run as the image entry point. Current pid=$$"

# Determines the host address.
# Unless HOST is set via run args (HOST=host.docker.internal), use default gateway IP (podman ptp)
GATEWAY_IP=$( ip route list | egrep default | cut -d" " -f3 )
export HOST="${HOST:-$GATEWAY_IP}"

# Starts Apache, unless --disable-apache
httpd -k start

# Run FPM via exec. 
exec /usr/local/sbin/php-fpm --fpm-config /etc/php/php-fpm.conf $@

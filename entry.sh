#!/bin/sh

set -e 

error() {
	echo "$@"
	exit 1
}

[[ $$ == "1" ]] || error "This script must be run as the image entry point. Current pid=$$"


SCRIPT_PATH=$(dirname "$0")

# Determines the host address.
# Unless HOST is set via run args (HOST=host.docker.internal), use default gateway IP (podman ptp)
GATEWAY_IP=$( ip route list | grep default | cut -d" " -f3 )
export HOST="${HOST:-$GATEWAY_IP}"

export HTTPD_PORT="${HTTPD_PORT:-80}"
export HTTPD_ROOT="${HTTPD_ROOT:-/var/www/app}"
export HTTPD_SERVERNAME="${HTTPD_SERVERNAME:-${HOSTNAME:-localhost}}"
export HTTPD_REALIP_HEADER="${HTTPD_REALIP_HEADER:-X-Forwarded-For}"

# Hook for overriding or setting variables
[ -f "${SCRIPT_PATH}/entry-config.sh" ] && source "${SCRIPT_PATH}/entry-config.sh"


# Starts SSH service if dropbear is installed
if apk info --installed dropbear &>/dev/null; then
  mkdir -p /etc/dropbear
  mkdir -p /root/.ssh && chmod -R 700 /root/.ssh
  echo "${SSHD_AUTH_PUBKEY}" > /root/.ssh/authorized_keys
  dropbear -REmsp ${SSHD_PORT:-22}
fi

# Starts Apache
httpd -k start

# Pre-exec hook: can terminate started services or start new ones OR replace exec
[ -f "${SCRIPT_PATH}/entry-run.sh" ] && source "${SCRIPT_PATH}/entry-run.sh"

# Run FPM via exec. 
exec /usr/local/sbin/php-fpm --fpm-config /etc/php/php-fpm.conf $@

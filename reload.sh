#!/bin/sh

set -e

# Reload Apache configuration
httpd -k graceful

# Reload FPM configuration
kill -USR2 1

# Production-ready PHP-FPM Docker Image

- php app mounted via bind mount. This is done by docker-compose.
- CLI executable via `docker exec -it <instance> php`

## Included extensions
- GD with WebP, PNG, JPEG support
- BCMath, GMP, ~~PHP Decimal (wait for next Alpine release)~~
- OpenSSL, Sodium, Argon2
- MySQLi, PDO MySQL, PDO SQLite
- OPcache, APCu

## Environment variables
Should be set via .env for symfony projects. For WP, config is set from the mounted app root.

## Notes
- `docker build -f /path/to/a/Dockerfile .` builds an image from Dockerfile using the context (files) at ". "
- `docker exec -it 9673bb9089f5 php -a`
- FPM executed under the `www-data` user whose home directory is `/var/www`. The mounted web app should reside there and have www-data ownership.
- FPM socket located at `/var/www/php-fpm.sock`
- /var/www expected to be bind mounted by the app in docker-compose.yaml
- Apache config: `ProxyPassMatch "\.php(/.*)?$" "fcgi://localhost:32768/var/www" flushpackets=on timeout=3600`
- **unix socket on bound mount works only for linux hosts**
- **host.docker.internal** works only on Docker for Mac

## TODOS
- create entry.sh script that does whatever magic it needs (e.g. update config files) and then `exec /fpm`. exec is needed so that signals are properly forwarded to the executed process (fpm) which stays in foreground.
- Add ENV settings to instruct the entry script to start apache and/or load Xdebug. Use env to set the host XDEBUG must connect to.
- Apache must be added together with mod_rpaf so that it can be used behing nginx when deployed e.g. via Plesk

**remember the keep the base image flexible enough to allow both production deployments (unix sockets, no debug, maybe apache)**

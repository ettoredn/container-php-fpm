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

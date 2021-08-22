# Production-ready PHP-FPM Image for Docker

This build of PHP-FPM is meant to be used in production or staging environments.

- Arguments provided to docker are passed to FPM, e.g. `docker run <image> -d zend_extension=xdebug.so -i`.
- Execute PHP's cli via `docker exec -it <instance> php`.
- Web application root is `/var/www/app`.
- Composer is not included.
- Extend PHP's settings by adding .ini files to `/usr/local/etc/php/conf.d`.
- Extend FPM pool's settings by adding .conf files to `/usr/local/etc/php-fpm.d`.
- `REMOTE_ADDR` and `REQUEST_SCHEME` are replaced with `X_FORWARDED_FOR` and `X_FORWARDED_PROTO`, respectively.

## Bundled Extensions

The following extension are included and *enabled by default*:

- GD with support for WebP, PNG, JPEG
- BCMath, GMP
- OpenSSL, Sodium, Argon2
- MySQLi, PDO MySQL
- OPcache, APCu

Additional extensions are available but *disabled by default*:

- ~~PHP Decimal (wait for next Alpine release)~~
- imagick (`-dextension=imagick.so)
- PhpRedis (`-dextension=redis.so`)
- Xdebug (`-dzend_extension=xdebug.so`)

## Build steps

- `docker build --file Dockerfile.74 --tag ghcr.io/themecraftstudio/php-fpm-7.4:latest .`
- `docker push ghcr.io/themecraftstudio/php-fpm-7.4`

## Notes

- `docker build -f /path/to/a/Dockerfile .` builds an image from Dockerfile using the context (files) at ". "
- `docker exec -it 9673bb9089f5 php -a`
- **unix socket on bound mount works only for linux hosts**
- **host.docker.internal** works only on Docker for Mac

## TODOS

- Use XDEBUG_REMOTE_HOST to set the remote host to connect to.

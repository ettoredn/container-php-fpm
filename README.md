# Production-ready PHP-FPM Image for Docker

- Arguments provided to docker are passed to FPM, e.g. `docker run <image> -dzend_extension=xdebug.so -i`.
- Execute PHP's cli via `docker exec -it <instance> php`.
- Web application root is `/var/www/app`.
- When using this as base image, add `RUN chwon -R apache:apache /var/www/app` to your Dockerfile.
- Composer is not included.
- `REMOTE_ADDR` and `REQUEST_SCHEME` are replaced with `X_FORWARDED_FOR` and `X_FORWARDED_PROTO`, respectively.

## Bundled Extensions

- GD with support for WebP, PNG, JPEG
- BCMath, GMP, ~~PHP Decimal (wait for next Alpine release)~~
- OpenSSL, Sodium, Argon2
- MySQLi, PDO MySQL, PDO SQLite
- OPcache, APCu

## Build steps

- `docker build --tag ghcr.io/themecraftstudio/php-fpm-7.4:latest .`
- `docker push ghcr.io/themecraftstudio/php-fpm-7.4`

## Notes

- `docker build -f /path/to/a/Dockerfile .` builds an image from Dockerfile using the context (files) at ". "
- `docker exec -it 9673bb9089f5 php -a`
- **unix socket on bound mount works only for linux hosts**
- **host.docker.internal** works only on Docker for Mac

## TODOS

- Use APP_DEBUG to toggle Xdebug. Use XDEBUG_REMOTE_HOST to set the remote host to connect to.

# Production-ready PHP-FPM container image

This build of PHP-FPM is meant to be used in production or staging environments.

- Arguments provided to docker are passed to FPM, e.g. `docker run <image> -d zend_extension=xdebug.so -i`.
- Execute PHP's cli via `docker exec -it <instance> php`.
- Web application root is `/var/www/app`.
- Composer is not included.
- Extend PHP's settings by adding .ini files to `/etc/php/conf.d`.
- Extend FPM pool's settings by adding .conf files to `/etc/php-fpm.d`.
- Extend/override Apache settings via `/etc/apache2/conf.d/app.conf`.
- `REMOTE_ADDR` and `REQUEST_SCHEME` are replaced with `X_FORWARDED_FOR` and `X_FORWARDED_PROTO`, respectively.
- The `HTTPS` header is automatically set to `on` for every request having `X_FORWARDED_PROTO == 'https'`

## Bundled Extensions

The following extension are included and *enabled by default*:

- GD with support for PNG, JPEG and WebP
- BCMath, GMP
- OpenSSL, Sodium, Argon2
- PDO PostgreSQL/MySQL, MySQLi
- OPcache, APCu

Additional extensions are available but *disabled by default*:

- [imagick](https://github.com/Imagick/imagick) (`-dextension=imagick.so`) !! requires additional build step `apk add imagemagick` (+114 MB)
- [PhpRedis](https://github.com/phpredis/phpredis) (`-dextension=redis.so`)
- [Xdebug](https://xdebug.org/) (`-dzend_extension=xdebug.so`)

## Build steps

- `docker build --file Dockerfile.81 --tag ghcr.io/themecraftstudio/php-fpm:8.1 .`
- `docker push ghcr.io/themecraftstudio/php-fpm:8.1`

## Notes

- `docker build -f /path/to/a/Dockerfile .` builds an image from Dockerfile using the context (files) at ". "
- `docker build -f Dockerfile.81 --target builder --tag builder-81 .` builds the intermediary builder image.
- `docker exec -it 9673bb9089f5 php -a`
- **unix socket on bound mount works only for linux hosts**
- **host.docker.internal** works only on Docker for Mac
- Build flags courtesy of [ClearLinux's PHP package](https://github.com/clearlinux-pkgs/php/blob/master/php.spec#L186)

## TODOS

- Use XDEBUG_REMOTE_HOST to set the remote host to connect to.

## References

- https://gitlab.alpinelinux.org/alpine/aports/-/issues/10627
- https://clang.llvm.org/docs/Toolchain.html

# Performance optimized PHP-FPM container image

Alpine-based performance optimized build of PHP-FPM for containerized production environments.

- Arguments provided to docker are passed to FPM, e.g. `docker run <image> -d zend_extension=xdebug.so -i`.
- Execute PHP's cli via `docker exec -it <instance> php`.
- Extend PHP's settings by adding .ini files to `/etc/php/conf.d`.
- Extend FPM pool's settings by adding .conf files to `/etc/php-fpm.d`.
- Extend/override Apache settings via `/etc/apache2/conf.d/app.conf`.
- Hook entry script by adding `/usr/local/bin/entry-config.sh` and `/usr/local/bin/entry-run.sh`
- `REMOTE_ADDR` and `REQUEST_SCHEME` HTTP headers are populated from `X_FORWARDED_FOR` and `X_FORWARDED_PROTO`, respectively.
- The `HTTPS` HTTP header is set to `on` for every request having `X_FORWARDED_PROTO == 'https'`.
- SSH access can be enabled by installing dropbear (`apk add --no-cache dropbear`) and setting root's pubkey using the appropriate environment variable (see below).
- Apache fcgi_proxy (connect) timeout is set to 300s

## Environment variables

| NAME                     | DEFAULT                       | DESCRIPTION                   |
| :----------------------- | :---------------------------- | :---------------------------- |
| `HOST`                   | default gateway               | Host address                  |
| `HTTPD_PORT`             | `80`                          |                               |
| `HTTPD_ROOT`             | `/var/www/app`                |                               |
| `HTTPD_SERVERNAME`       | `$HOSTNAME` or `localhost`    |                               |
| `HTTPD_REALIP_HEADER`    | `X-Forwarded-For`             |                               |
| `SSHD_PORT`              | `22`                          | if dropbear is installed      |
| `SSHD_AUTH_PUBKEY`       |                               | if dropbear is installed      |

## Bundled extensions

The following extensions are included and *enabled by default*:

- GD with support for PNG, JPEG and WebP
- BCMath, GMP
- OpenSSL, Sodium, Argon2
- PDO PostgreSQL/MySQL, MySQLi
- OPcache, APCu

Additional extensions are available but *disabled by default*:

- [PhpRedis](https://github.com/phpredis/phpredis) (`-dextension=redis.so`)
- [AMQP](https://github.com/php-amqp/php-amqp) (`-dextension=amqp.so`)
- [Xdebug](https://xdebug.org/) (`-dzend_extension=xdebug.so`)

## Notes

- `docker build -f Containerfile.81 --target builder --tag builder-81 .` builds the intermediary builder image.
- Build flags courtesy of [ClearLinux's PHP package](https://github.com/clearlinux-pkgs/php/blob/master/php.spec#L186)

## TODO

- include `msmtp` for sending emails

## References

- https://gitlab.alpinelinux.org/alpine/aports/-/issues/10627
- https://clang.llvm.org/docs/Toolchain.html

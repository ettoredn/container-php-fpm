# Production-ready PHP-FPM Docker Image

- CLI executable via `docker exec -it <instance> php`
- Put the web app in `/var/www/app`
- composer not included
- `RUN chwon -R apache:apache /var/www/app` when using this as base image

## Included extensions
- GD with WebP, PNG, JPEG support
- BCMath, GMP, ~~PHP Decimal (wait for next Alpine release)~~
- OpenSSL, Sodium, Argon2
- MySQLi, PDO MySQL, PDO SQLite
- OPcache, APCu

## Notes
- `docker build -f /path/to/a/Dockerfile .` builds an image from Dockerfile using the context (files) at ". "
- `docker exec -it 9673bb9089f5 php -a`
- **unix socket on bound mount works only for linux hosts**
- **host.docker.internal** works only on Docker for Mac
- build with `docker build --tag ghcr.io/themecraftstudio/php-fpm-7.4:latest .`
- build with `docker push ghcr.io/themecraftstudio/php-fpm-7.4`

## TODOS
- Add ENV settings or entry script options to toggle Xdebug. Maybe use ENV to set Xdebug's connect host.
- Compile mod_rpaf which is needed when Apache is used behind a reverse proxy (e.g. Plesk/nginx)

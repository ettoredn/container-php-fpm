# docker build --target builder .
# Build PHP from source
FROM php:7.4-fpm-alpine AS builder
ENV PHP_CFLAGS -fstack-protector-strong -fpic -fpie -O3 -fno-trapping-math -fno-semantic-interposition -falign-functions=32 -fno-lto -fno-math-errno -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64
ENV PHP_CPPFLAGS ${PHP_CFLAGS}
ENV PHP_LDFLAGS -Wl,-O1 -pie
ENV PHP_BUILD_DEPS autoconf dpkg-dev dpkg file g++ gcc libc-dev make pkgconf re2c libxml2-dev openssl-dev sqlite-dev libedit-dev bzip2-dev curl-dev libpng-dev libwebp-dev libjpeg-turbo-dev gmp-dev icu-dev oniguruma-dev libsodium-dev argon2-dev libzip-dev
ENV PHP_PREFIX=/root/php-build
RUN docker-php-source extract
WORKDIR /usr/src/php
RUN apk update && apk upgrade && apk add --virtual .php-deps-dev ${PHP_BUILD_DEPS}
RUN CFLAGS="${PHP_CFLAGS}" CPPFLAGS="${PHP_CPPFLAGS}" LDFLAGS="${PHP_LDFLAGS}" ./configure \
  --enable-option-checking=fatal --prefix=${PHP_PREFIX} --build=x86_64-linux-musl --with-config-file-path=/usr/local/etc/php \
  --enable-cli --enable-fpm --with-fpm-user=www-data --with-fpm-group=www-data --disable-cgi --without-pear --disable-short-tags \
  --with-sodium --with-password-argon2 --with-openssl --with-system-ciphers \
  --enable-mysqlnd --with-pdo-mysql=mysqlnd --with-mysqli=mysqlnd \
  --with-zip --with-zlib --with-bz2 \
  --enable-bcmath --with-gmp --enable-mbstring --with-iconv \
  --enable-gd --with-webp --with-jpeg --enable-exif \
  --enable-shmop --enable-re2c-cgoto --enable-soap --enable-sockets  --with-curl --with-libedit --enable-intl --enable-calendar  --enable-pcntl
RUN make --jobs=$( getconf _NPROCESSORS_ONLN ) && make install
CMD ["/bin/sh"]

# Create the image
FROM alpine
ENV PHP_DEPS libxml2 openssl sqlite-libs libedit bzip2 libcurl libpng libwebp libjpeg-turbo gmp icu-libs oniguruma libsodium argon2-libs libzip
RUN apk update && apk upgrade && apk add --virtual .php-deps ${PHP_DEPS}
COPY --from=builder /usr/src/php /usr/src/php
WORKDIR /usr/src/php
# ENTRYPOINT ["/usr/local/bin/php-fpm"]
ADD README.md relative-to-workdir.ini
CMD ["/bin/sh"]

# Run php docker run --entrypoint=/bin/sh php

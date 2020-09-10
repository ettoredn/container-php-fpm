# docker build --target builder .
# Build PHP from source
FROM php:7.4-fpm-alpine AS builder
# removed -fpic
ENV PHP_CFLAGS -fstack-protector-strong -fpie -O3 -fno-trapping-math -fno-semantic-interposition -falign-functions=32 -fno-lto -fno-math-errno -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64
ENV PHP_CPPFLAGS ${PHP_CFLAGS}
ENV PHP_LDFLAGS -Wl,-O1 -pie
ENV PHP_BUILD_DEPS git autoconf dpkg-dev dpkg file g++ gcc libc-dev make pkgconf re2c libxml2-dev openssl-dev sqlite-dev libedit-dev bzip2-dev curl-dev libpng-dev libwebp-dev libjpeg-turbo-dev gmp-dev icu-dev oniguruma-dev libsodium-dev argon2-dev libzip-dev
ENV PHP_XDEBUG_SRC https://xdebug.org/files/xdebug-2.9.6.tgz
ENV PHP_APCU_SRC https://github.com/krakjoe/apcu/archive/v5.1.18.tar.gz
RUN apk update && apk upgrade && apk add --virtual .php-deps-dev ${PHP_BUILD_DEPS}
RUN rm -rf /usr/local/lib/php /usr/local/sbin/php-fpm /usr/local/bin/php
RUN docker-php-source extract
RUN mkdir -p /usr/src/apcu && cd /usr/src/apcu && curl --location ${PHP_APCU_SRC} | tar xzf - --strip-components=1
RUN mkdir -p /usr/src/xdebug && cd /usr/src/xdebug && curl --location ${PHP_XDEBUG_SRC} | tar xzf - --strip-components=1
WORKDIR /usr/src/php
RUN CFLAGS="${PHP_CFLAGS}" CPPFLAGS="${PHP_CPPFLAGS}" LDFLAGS="${PHP_LDFLAGS}" ./configure \
  --enable-option-checking=fatal --prefix=/usr/local --build=x86_64-linux-musl --with-config-file-path=/usr/local/etc/php \
  --enable-cli --enable-fpm --with-fpm-user=www-data --with-fpm-group=www-data --disable-cgi --disable-short-tags \
  --with-sodium --with-password-argon2 --with-openssl --with-system-ciphers \
  --enable-mysqlnd --with-pdo-mysql=mysqlnd --with-mysqli=mysqlnd \
  --with-zip --with-zlib --with-bz2 \
  --enable-bcmath --with-gmp --enable-mbstring --with-iconv \
  --enable-gd --with-webp --with-jpeg --enable-exif \
  --enable-shmop --enable-re2c-cgoto --enable-soap --enable-sockets  --with-curl --with-libedit --enable-intl --enable-calendar  --enable-pcntl
RUN make --jobs=$( getconf _NPROCESSORS_ONLN ) && make install
RUN cd /usr/src/apcu && phpize \
  && ./configure --with-php-config=/usr/local/bin/php-config \
  && make --jobs=$( getconf _NPROCESSORS_ONLN ) \
  && make install
RUN cd /usr/src/xdebug && phpize \
  && ./configure --with-php-config=/usr/local/bin/php-config --enable-xdebug \
  && make --jobs=$( getconf _NPROCESSORS_ONLN ) \
  && make install
CMD ["/bin/sh"]

# Create the image
FROM alpine AS production
ENV PHP_DEPS libxml2 openssl sqlite-libs libedit libbz2 libcurl libpng libwebp libjpeg-turbo gmp icu-libs oniguruma libsodium argon2-libs libzip
ENV HTTP_ROOT /var/www/app
RUN apk update && apk upgrade && apk add apache2 apache2-proxy && apk add --virtual .php-deps ${PHP_DEPS} && mkdir -p ${HTTP_ROOT}
COPY --from=builder /usr/local/bin/phar /usr/local/bin/
COPY --from=builder /usr/local/bin/phar.phar /usr/local/bin/
COPY --from=builder /usr/local/bin/php /usr/local/bin/
COPY --from=builder /usr/local/bin/php-config /usr/local/bin/
COPY --from=builder /usr/local/lib/php/extensions/ /usr/local/lib/php/extensions/
COPY --from=builder /usr/local/sbin/php-fpm /usr/local/sbin/
COPY --from=builder /usr/local/etc/php-fpm.d/docker.conf /usr/local/etc/php-fpm.d/docker.conf
ADD conf/php-fpm.conf /usr/local/etc/php-fpm.conf
ADD conf/php.ini /usr/local/etc/php/php.ini
ADD conf/apache.conf /etc/apache2/httpd.conf
ADD entry.sh /usr/local/bin/entry.sh
#RUN addgroup -S www-data && adduser -S -D -h /var/www -G www-data www-data
ENTRYPOINT ["/usr/local/bin/entry.sh"]
CMD ["--nodaemonize"]
EXPOSE 9000/tcp
EXPOSE 80/tcp

# Can be used via docker-composer 'build: target: development'
# FROM alpine AS development;
# kill --signal USR2 1

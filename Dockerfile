# Build PHP from source
FROM php:7.4-fpm-alpine AS builder
RUN docker-php-source extract

# Create the image
FROM alpine
#The environment variables set using ENV will persist when a container is run from the resulting image. You can view the values using docker inspect, and change them using docker run --env <key>=<value>
ENV magic=true wizard=false
RUN local_env=value apk update
WORKDIR /root/
COPY --from=builder /usr/src/php .
# ENTRYPOINT ["/usr/local/bin/php-fpm"]
ADD README.md relative-to-workdir.ini
CMD ["/bin/sh"]

# Run php docker run --entrypoint=/bin/sh php

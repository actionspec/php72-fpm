# From PHP 7.2 FPM based on Alpine Linux
FROM php:7.2-fpm-alpine

# Maintainer
MAINTAINER ActionSpec, LLC

# Install dependencies
RUN apk --update add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.6/main curl curl-dev 
RUN apk --update add --no-cache \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    --repository http://dl-cdn.alpinelinux.org/alpine/v3.6/main \
      shadow libxml2-dev freetype-dev libpng-dev libjpeg-turbo-dev imagemagick-dev icu-dev openssl-dev gcc g++ autoconf make \
    && docker-php-ext-configure gd \
        --with-gd \
        --with-freetype-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ \
    && yes '' | pecl install apcu-5.1.8 \
    && docker-php-ext-install ctype curl bc-math dom gd hash iconv intl json mbstring mysqli opcache openssl pdo pdo_mysql phar posix session simplexml soap sockets tokenizer xml xmlrpc xmlwriter xsl zip \
    && docker-php-ext-enable apcu \
    && apk del gcc g++ autoconf make \
    && rm -rf /var/cache/apk/*

# Disable access log for php-fpm
RUN sed -e '/access.log/s/^/;/' -i /usr/local/etc/php-fpm.d/docker.conf
RUN echo -e "[PHP]\nlog_errors = yes" > /usr/local/etc/php/conf.d/errorlog.ini


# UTF-8 default
ENV LANG en_US.utf8

CMD ["php-fpm"]

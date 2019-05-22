FROM php:7.2-fpm-alpine

# speed  mirror
RUN  \
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && sed -i 's/http/https/g' /etc/apk/repositories

# depend package
RUN  \
    # zip bz2
    apk add libzip-dev libzip bzip2-dev \

    #  pecl
        autoconf make dpkg-dev dpkg file g++ gcc libc-dev pkgconf re2c \

    # imagick
      imagemagick-dev  make  \ 

    #  event
        libevent-dev   openssl-dev \

    # ext php
        php7-gd \

    # bash is needed for some scripts
        bash git

# bz2
RUN \
   docker-php-ext-install bz2 \

    # zip
    && docker-php-ext-install zip \

    # mysql_pdo
    && docker-php-ext-install pdo_mysql \

    # imagick 
    && pecl install imagick  \
    && docker-php-ext-enable imagick  \

    # pcntl - multithreading
    && docker-php-ext-install pcntl \

    # redis
    && pecl install redis \
    && docker-php-ext-enable redis \

    # socket lib
    && docker-php-ext-install sockets \

    # libevent needs sockets to be loaded. but 'l' is before 's' in alphnum
    # rename ini to prevent php-startup-errors
    && mv \
      /usr/local/etc/php/conf.d/docker-php-ext-sockets.ini \
      /usr/local/etc/php/conf.d/01_docker-php-ext-sockets.ini \

    # libevent - performance to scheduled events
    && pecl install event \
    && docker-php-ext-enable event \

    # remove dev-packaged
    && apk del autoconf g++ libtool make \

    # remove tmp-data
    && rm -rf /tmp/* /var/cache/apk/*

# Install Composer and make it available in the PATH
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

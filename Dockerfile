FROM php:7.2-fpm-alpine

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
&& sed -i 's/http/https/g' /etc/apk/repositories 

RUN apk add  autoconf dpkg-dev dpkg file g++ gcc libc-dev make pkgconf re2c \
	libzip-dev libzip bzip2-dev \
    php7 php7-fpm php7-gd php7-mbstring  php7-session  php7-opcache php7-curl \
    php7-json  php7-mcrypt php7-gettext php7-xml  php7-phar php7-openssl php7-dom\
	&& ( \
		# pecl install protobuf \
		apk add php7-dev && cd /tmp  \
		&& wget https://github.com/allegro/php-protobuf/archive/v0.12.3.tar.gz \
		&& tar -zxvf v0.12.3.tar.gz && cd php-protobuf-0.12.3 && phpize && ./configure --with-php-config=/usr/local/bin/php-config \
		&& make && make install && docker-php-ext-enable protobuf \
	)\
	&& docker-php-ext-install bz2  zip pdo_mysql \
	&& pecl install -o -f redis && docker-php-ext-enable  redis \
	&& rm -rf /var/cache/apk/* 
	
RUN mkdir /var/log/php \
	&& chown -R www-data:www-data /var/log/php \ 
	&& chmod 776 -R /var/log/php \
	&& chown -R www-data:www-data /var/www/html \
	&& chmod 777 -R /var/www/html


 
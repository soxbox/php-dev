FROM php:7.0-apache
MAINTAINER tim <tim@soxbox.co>

ADD http://www.cacert.org/certs/root.crt /usr/local/share/ca-certificates/cacert.crt
RUN update-ca-certificates

RUN apt-get update && apt-get upgrade -y  && \
	apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
		libbz2-dev \
		git \
		libpcre3-dev \
		libmcrypt-dev \
		libxml2-dev \
		zlib1g-dev \
		libssh2-1 \
		libssh2-1-dev \
		libpng-dev \
		libzip-dev \
        zip \
		--no-install-recommends

ENV PHP_INI_DIR /usr/local/etc/php
RUN set -eux; \
	mkdir -p "$PHP_INI_DIR/conf.d";


COPY docker-php-ext-* docker-php-entrypoint /usr/local/bin/

ADD conf/php.ini /usr/local/etc/php/php.ini
ADD conf/www.conf /usr/local/etc/php-fpm.d/www.conf

RUN ln -sf /usr/share/zoneinfo/US/Arizona /etc/localtime && \
  echo "Us/Arizona" > /etc/timezone

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install gd \
  && docker-php-ext-install mysqli \
  && docker-php-ext-install bz2 \
  && docker-php-ext-configure zip --with-libzip \
  && docker-php-ext-install zip \
  && docker-php-ext-install pdo \
  && docker-php-ext-install pdo_mysql \
  && docker-php-ext-install mbstring \
  && docker-php-ext-install mcrypt \
  && docker-php-ext-install opcache \
  && cp /usr/local/bin/php /usr/bin/ \
  && echo "extension=phalcon.so" > /usr/local/etc/php/conf.d/phalcon.ini \
  && echo "extension=bcmath.so" > /usr/local/etc/php/conf.d/bcmath.ini

ENV PHALCON_VERSION=3.4.2

WORKDIR /usr/src/php/ext/

# # Compile Phalcon
RUN set -xe && \
  curl -LO https://github.com/phalcon/cphalcon/archive/v${PHALCON_VERSION}.tar.gz && \
  tar xzf v${PHALCON_VERSION}.tar.gz && cd cphalcon-${PHALCON_VERSION}/build &&  ./install && \
  echo "extension=phalcon.so" > /usr/local/etc/php/conf.d/phalcon.ini && \
  cd ../.. && rm -rf v${PHALCON_VERSION}.tar.gz cphalcon-${PHALCON_VERSION} 

RUN docker-php-source extract \
  && cd /usr/src/php/ext/bcmath \
  && phpize && ./configure --with-php-config=/usr/local/bin/php-config && make && make install \
  && make clean \
  && docker-php-source delete


RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

RUN a2enmod rewrite

EXPOSE 80

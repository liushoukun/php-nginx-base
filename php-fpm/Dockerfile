FROM php:8.3-fpm-alpine

# install necessary alpine packages
RUN apk update && apk add --no-cache \
    zip \
    unzip \
    dos2unix \
    supervisor \
    libpng-dev \
    openssl-dev \
    libzip-dev \
    freetype-dev \
    libjpeg-turbo-dev \
    bash \
    autoconf \
    lz4-dev \
    git \
    supervisor

# compile native PHP packages
RUN docker-php-ext-install \
    gd \
    pcntl \
    bcmath \
    mysqli \
    pdo_mysql

# configure packages
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
# install additional packages from PECL

RUN pecl channel-update pecl.php.net && \
    pecl install redis igbinary msgpack  mongodb opcache && \
    docker-php-ext-enable redis igbinary msgpack mongodb opcache


# set composer related environment variables
ENV PATH="/composer/vendor/bin:$PATH" \
    COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_HOME=/composer


RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer




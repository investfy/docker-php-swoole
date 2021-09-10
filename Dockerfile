FROM php:latest

ENV TZ=UTC

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && \
    apt-get install -y g++ zip unzip

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN pecl channel-update https://pecl.php.net/channel.xml && \
    pecl install swoole && \
    pecl clear-cache && \
    touch /usr/local/etc/php/conf.d/swoole.ini && \
    echo 'extension=swoole.so' > /usr/local/etc/php/conf.d/swoole.ini

RUN docker-php-ext-configure pcntl --enable-pcntl && \
    docker-php-ext-install pcntl && \
    docker-php-ext-install pdo pdo_mysql && \
    docker-php-ext-install bcmath

RUN apt-get -y autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

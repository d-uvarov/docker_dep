FROM php:7.4.1-fpm

WORKDIR /root

RUN apt-get update
RUN apt-get -y install gcc libpcre3-dev zlib1g-dev libicu-dev g++ libssl-dev
RUN apt-get -y install git

RUN docker-php-ext-configure intl
RUN docker-php-ext-install intl
RUN pecl install redis
RUN echo "extension=redis.so" >> /usr/local/etc/php/conf.d/docker-php-ext-redis.ini

RUN apt-get -y install libmagickwand-dev libmagickcore-dev
RUN pecl install imagick
RUN echo "extension=imagick.so" >> /usr/local/etc/php/conf.d/docker-php-ext-imagick.ini

RUN apt-get -y install libzip-dev
RUN docker-php-ext-install zip
RUN docker-php-ext-install pdo
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install opcache
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
RUN sed -i 's/expose_php.*/expose_php = off/' "$PHP_INI_DIR/php.ini"

RUN echo "opcache.enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini
RUN echo "opcache.validate_timestamps=0" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini
RUN echo "opcache.memory_consumption=128" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini
RUN echo "opcache.interned_strings_buffer=8" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini
RUN echo "opcache.max_accelerated_files=4000" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN curl -sL https://deb.nodesource.com/setup_13.x | bash -
RUN apt-get install -y nodejs

RUN curl -LO https://deployer.org/deployer.phar
RUN mv deployer.phar /usr/local/bin/dep
RUN chmod +x /usr/local/bin/dep

RUN echo "alias ll='ls -alF --color=auto'" >> ~/.bashrc
RUN echo "PS1='${debian_chroot:+($debian_chroot)}\h:\$ '" >> ~/.bashrc

EXPOSE 9000


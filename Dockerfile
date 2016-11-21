FROM wordpress:4.5.2-fpm

RUN apt-get update && apt-get install -y libmemcached-dev tidy csstidy less && apt-get clean

RUN curl -o memcached.tgz -SL http://pecl.php.net/get/memcached-2.2.0.tgz \
        && tar -xf memcached.tgz -C /usr/src/php/ext/ \
        && rm memcached.tgz \
        && mv /usr/src/php/ext/memcached-2.2.0 /usr/src/php/ext/memcached
RUN curl -o memcache.tgz -SL http://pecl.php.net/get/memcache-3.0.8.tgz \
        && tar -xf memcache.tgz -C /usr/src/php/ext/ \
        && rm memcache.tgz \
        && mv /usr/src/php/ext/memcache-3.0.8 /usr/src/php/ext/memcache
RUN curl -o zip.tgz -SL http://pecl.php.net/get/zip-1.13.1.tgz \
        && tar -xf zip.tgz -C /usr/src/php/ext/ \
        && rm zip.tgz \
        && mv /usr/src/php/ext/zip-1.13.1 /usr/src/php/ext/zip

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
        && chmod +x wp-cli.phar \
        && mv wp-cli.phar /usr/local/bin/wp

RUN docker-php-ext-install memcached
RUN docker-php-ext-install memcache
RUN docker-php-ext-install zip

COPY nginx.conf /var/www/html/
RUN chown www-data:www-data /var/www/html/nginx.conf

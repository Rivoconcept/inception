FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    php7.4-fpm php7.4-mysql php7.4-gd php7.4-xml php7.4-curl curl wget mariadb-client \
    && rm -rf /var/lib/apt/lists/*

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

RUN mkdir -p /run/php /var/www/html \
    && chown -R www-data:www-data /var/www/html /run/php

WORKDIR /var/www/html

RUN curl -O https://wordpress.org/latest.tar.gz && \
    tar -xvzf latest.tar.gz --strip-components=1 && \
    rm latest.tar.gz

COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY ./tools/auto-install.sh /auto-install.sh

RUN chown -R www-data:www-data /var/www/html && \
    chmod +x /auto-install.sh

EXPOSE 9000

CMD ["/auto-install.sh"]

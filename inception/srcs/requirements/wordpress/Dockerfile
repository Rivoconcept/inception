FROM debian:bullseye

# Installer PHP-FPM et extensions nécessaires
RUN apt-get update && apt-get install -y \
    php7.4-fpm \
    php7.4-mysql \
    php7.4-gd \
    php7.4-xml \
    php7.4-curl \
    curl wget unzip \
    && rm -rf /var/lib/apt/lists/*

# Installer WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Créer dossiers et permissions
RUN mkdir -p /run/php /var/www/html \
    && chown -R www-data:www-data /var/www/html /run/php

WORKDIR /var/www/html

COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY ./tools/auto-install.sh /auto-install.sh

RUN chmod +x /auto-install.sh

RUN echo "<?php header('HTTP/1.1 200 OK'); echo 'OK'; ?>" > /var/www/html/health.php

EXPOSE 9000

CMD ["/auto-install.sh"]
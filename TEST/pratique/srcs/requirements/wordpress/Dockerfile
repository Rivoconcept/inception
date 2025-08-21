FROM debian:bullseye-slim

LABEL maintainer="rhanitra.42.fr"

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates php7.4-fpm php7.4-mysql php7.4-gd php7.4-xml php7.4-curl wget \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/php /var/www/html \
    && chown -R www-data:www-data /var/www/html /run/php

COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

WORKDIR /var/www/html
RUN wget --no-check-certificate https://wordpress.org/latest.tar.gz \
    && tar -xzf latest.tar.gz --strip-components=1 \
    && rm latest.tar.gz \
    && chown -R www-data:www-data . \
    && chmod 755 /var/www/html

RUN if [ -f wp-config-sample.php ]; then \
        cp wp-config-sample.php wp-config.php; \
        chown www-data:www-data wp-config.php; \
        chmod 640 wp-config.php; \
    fi

COPY conf/ /var/www/html/wp-config/

EXPOSE 9000

CMD ["php-fpm7.4", "-F"]

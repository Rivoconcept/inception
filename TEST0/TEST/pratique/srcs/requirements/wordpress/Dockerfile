# FROM debian:bullseye-slim

# LABEL maintainer="rhanitra.42.fr"

# RUN apt-get update && apt-get install -y --no-install-recommends \
#     ca-certificates php7.4-fpm php7.4-mysql php7.4-gd php7.4-xml php7.4-curl wget \
#     && rm -rf /var/lib/apt/lists/*

# RUN mkdir -p /run/php /var/www/html \
#     && chown -R www-data:www-data /var/www/html /run/php

# COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

# WORKDIR /var/www/html
# RUN wget --no-check-certificate https://wordpress.org/latest.tar.gz \
#     && tar -xzf latest.tar.gz --strip-components=1 \
#     && rm latest.tar.gz \
#     && chown -R www-data:www-data . \
#     && chmod 755 /var/www/html

# RUN if [ -f wp-config-sample.php ]; then \
#         cp wp-config-sample.php wp-config.php; \
#         chown www-data:www-data wp-config.php; \
#         chmod 640 wp-config.php; \
#     fi

# COPY conf/ /var/www/html/wp-config/

# EXPOSE 9000

# CMD ["php-fpm7.4", "-F"]

FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    php7.4-fpm php7.4-mysql php7.4-gd php7.4-xml php7.4-curl curl wget mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

RUN mkdir -p /run/php /var/www/html \
    && chown -R www-data:www-data /var/www/html /run/php

WORKDIR /var/www/html

# Télécharge WordPress
RUN curl -O https://wordpress.org/latest.tar.gz && \
    tar -xvzf latest.tar.gz --strip-components=1 && \
    rm latest.tar.gz

COPY ./conf/wp-config.php /var/www/html/wp-config.php
COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY ./tools/auto-install.sh /auto-install.sh

RUN chown -R www-data:www-data /var/www/html && \
    chmod +x /auto-install.sh

EXPOSE 9000

CMD ["/auto-install.sh"]

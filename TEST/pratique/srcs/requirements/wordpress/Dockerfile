# Utiliser une version stable de Debian (11-slim)
FROM debian:bullseye-slim

LABEL maintainer="rhanitra.42.fr"

# Installer PHP et les extensions requises
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    php7.4-fpm \
    php7.4-mysql \
    php7.4-gd \
    php7.4-xml \
    php7.4-curl \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Configurer PHP-FPM et les répertoires
RUN mkdir -p /run/php /var/www/html && \
    chown -R www-data:www-data /var/www/html /run/php && \
    sed -i 's/listen = \/run\/php\/php7.4-fpm.sock/listen = 9000/g' /etc/php/7.4/fpm/pool.d/www.conf && \
    sed -i 's/;clear_env = no/clear_env = no/g' /etc/php/7.4/fpm/pool.d/www.conf

COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

# Télécharger et configurer WordPress
WORKDIR /var/www/html
RUN wget --no-check-certificate https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz --strip-components=1 && \
    rm latest.tar.gz && \
    chown -R www-data:www-data . && \
    chmod 755 /var/www/html

# Create wp-config from sample
RUN if [ -f wp-config-sample.php ]; then \
    cp wp-config-sample.php wp-config.php; \
    chown www-data:www-data wp-config.php; \
    chmod 640 wp-config.php; \
    fi

# Copier les fichiers de configuration de WordPress
COPY conf/ /var/www/html/wp-config/
# Copier et configurer wp-config.php
# COPY conf/wp-config.php /var/www/html/
RUN chown www-data:www-data /var/www/html/wp-config.php && \
    chmod 640 /var/www/html/wp-config.php

# Exposer le port PHP-FPM (par défaut 9000)
EXPOSE 9000

# Lancer php-fpm via le lien absolu créé pendant le build
CMD ["php-fpm7.4", "-F"]

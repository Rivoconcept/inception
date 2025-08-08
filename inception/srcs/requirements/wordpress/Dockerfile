# Utilise une image légère avec PHP et extensions nécessaires
FROM debian:bullseye

# Met à jour le système et installe PHP + extensions, wget, curl, mariadb-client
RUN apt-get update && apt-get install -y \
    php php-fpm php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip \
    wget curl mariadb-client \
    unzip less vim \
    && apt-get clean

# Télécharge wp-cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Crée un utilisateur www
RUN useradd -ms /bin/bash www

# Crée les dossiers nécessaires
RUN mkdir -p /var/www/html

# Copie le script d'entrée
COPY ./tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Copie le fichier de configuration PHP personnalisé (facultatif)
# COPY ./conf/php.ini /etc/php/7.4/fpm/php.ini

# Définit l'utilisateur pour le dossier WordPress
RUN chown -R www:www /var/www/html

USER www
WORKDIR /var/www/html

# Expose le port utilisé par PHP-FPM
EXPOSE 9000

# Lance le script à l’entrée du conteneur
ENTRYPOINT [ "/entrypoint.sh" ]

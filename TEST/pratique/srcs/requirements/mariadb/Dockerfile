# Utiliser une version stable de Debian (Bullseye Slim)
FROM debian:bullseye-slim

LABEL maintainer="rhanitra.42.fr"

# Installer MariaDB directement depuis le dépôt Debian
RUN apt-get update && apt-get install -y \
    mariadb-server \
    && rm -rf /var/lib/apt/lists/*

# Créer et définir les permissions pour les répertoires MySQL
RUN mkdir -p /var/run/mysqld /var/lib/mysql && \
    chown -R mysql:mysql /var/run/mysqld /var/lib/mysql && \
    chmod 777 /var/run/mysqld

# Configuration du volume
VOLUME ["/var/lib/mysql"]

# Copier le script d'initialisation
COPY ./tools/init.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 3306

# Lancer MariaDB en avant-plan
CMD ["/docker-entrypoint.sh"]
COPY ./tools/init.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 3306

# Lancer MariaDB en avant-plan
CMD ["/docker-entrypoint.sh"]

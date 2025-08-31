voici les secretkey
rhanitra@rhanitra-VirtualBox:~/Documents/DEV/inception/inception/pratique/secrets$ cat MYSQL_PASSWORD.txt 
wordpress_passwordrhanitra@rhanitra-VirtualBox:~/Documents/DEV/inception/inception/pratique/secrets$ cat MYSQL_ROOT_PASSWORD.txt 
rootpasswordrhanitra@rhanitra-VirtualBox:~/Documents/DEV/inception/inception/pratique/secrets$ cat WORDPRESS_ADMIN_PASSWORD.txt 
Rhanitra$01rhanitra@rhanitra-VirtualBox:~/Documents/DEV/inception/inception/pratique/secrets$ cat WORDPRESS_DB_PASSWORD.txt 
wordpress_passwordrhanitra@rhanitra-VirtualBox:~/Documents/DEV/inception/inception/pratique/secrets$ cat WORDPRESS_USER_PASSWORD.txt 
Rhanitra$01rhanitra@rhanitra-VirtualBox:~/Documents/DEV/inception/inception/pratique/secrets$ 


pour mariadb :
my.cnf:
[mysqld]
skip-host-cache
skip-name-resolve
character-set-server = utf8mb4
collation-server = utf8mb4_general_ci
sql_mode = STRICT_TRANS_TABLES
max_allowed_packet = 64M
datadir=/var/lib/mysql
socket=/var/run/mysqld/mysqld.sock
bind-address=0.0.0.0
port=3306
user=mysql

init.sh:
#!/bin/bash
set -e

DATA_DIR="/var/lib/mysql"

mkdir -p /var/run/mysqld
chown -R mysql:mysql /var/run/mysqld

if [ ! -d "$DATA_DIR/mysql" ] || [ ! -f "$DATA_DIR/.initialized" ]; then
    echo "[INFO] Initializing MariaDB..."

    mysqld --initialize-insecure --user=mysql --datadir="$DATA_DIR"

    INIT_SQL="/tmp/init.sql"
    cat > "$INIT_SQL" <<EOF
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '$(cat /run/secrets/MYSQL_PASSWORD)';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '$(cat /run/secrets/MYSQL_ROOT_PASSWORD)';
FLUSH PRIVILEGES;
EOF

    mysqld --datadir="$DATA_DIR" --init-file="$INIT_SQL" &
    PID=$!
    wait $PID

    touch "$DATA_DIR/.initialized"
    echo "[INFO] MariaDB initialized!"
fi

exec mysqld --datadir="$DATA_DIR"


Dockerfile:
FROM debian:bullseye

RUN apt-get update && apt-get install -y mariadb-server && rm -rf /var/lib/apt/lists/*

COPY ./conf/my.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY ./tools/init.sh /init.sh
RUN chmod +x /init.sh

CMD ["/init.sh"]

pour nginx:
default.conf:
server {
    listen 443 ssl;
    server_name ${DOMAIN_NAME};

    ssl_certificate /etc/ssl/private/nginx.crt;
    ssl_certificate_key /etc/ssl/private/nginx.key;

    root /var/www/html;
    index index.php index.html;

    location / {
        try_files $uri $uri/ /index.php?$args;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass wordpress:9000;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
}

start.sh:
#!/bin/bash
set -e

CERT_DIR="/etc/ssl/private"
CRT_FILE="$CERT_DIR/nginx.crt"
KEY_FILE="$CERT_DIR/nginx.key"

if [ ! -f "$CRT_FILE" ] || [ ! -f "$KEY_FILE" ]; then
    echo "[INFO] Generating SSL certificates..."
    mkdir -p "$CERT_DIR"
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout "$KEY_FILE" \
        -out "$CRT_FILE" \
        -subj "/C=FR/ST=France/L=Paris/O=42/OU=Inception/CN=${DOMAIN_NAME}"
    chmod 644 "$CRT_FILE"
    chmod 600 "$KEY_FILE"
fi

echo "[INFO] Starting NGINX..."

nginx -g "daemon off;"

Dockerfile:
FROM debian:bullseye

RUN apt-get update && apt-get install -y nginx openssl netcat && rm -rf /var/lib/apt/lists/*

COPY ./conf/default.conf /etc/nginx/conf.d/default.conf

COPY ./start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]

pour wordpress:
www.conf:
[www]
user = www-data
group = www-data
listen = 0.0.0.0:9000
pm = dynamic
pm.max_children = 5
pm.start_servers = 2
pm.min_spare_servers = 1
pm.max_spare_servers = 3
clear_env = no

auto-install.sh:
#!/bin/bash
set -e

echo "[INFO] Creating wp-config.php..."
wp config create \
    --dbname="$WORDPRESS_DB_NAME" \
    --dbuser="$WORDPRESS_DB_USER" \
    --dbpass="$(cat /run/secrets/WORDPRESS_DB_PASSWORD)" \
    --dbhost="$WORDPRESS_DB_HOST" \
    --force \
    --allow-root

if ! wp core is-installed --allow-root; then
    echo "[INFO] Installing WordPress..."

    wp core install \
        --url="${WORDPRESS_URL}" \
        --title="${WORDPRESS_TITLE}" \
        --admin_user="${WORDPRESS_ADMIN_USER}" \
        --admin_password="$(cat /run/secrets/WORDPRESS_ADMIN_PASSWORD)" \
        --admin_email="${WORDPRESS_ADMIN_EMAIL}" \
        --skip-email \
        --allow-root

    wp user create "${WORDPRESS_USER}" "${WORDPRESS_USER_EMAIL}" \
        --user_pass="$(cat /run/secrets/WORDPRESS_USER_PASSWORD)" \
        --role=subscriber \
        --allow-root

    wp theme install twentytwentythree --activate --allow-root

    echo "[INFO] WordPress installation completed!"
else
    echo "[INFO] WordPress is already installed!"
fi


# export WORDPRESS_DB_PASSWORD="$(cat /run/secrets/WORDPRESS_DB_PASSWORD)"
exec php-fpm7.4 -F

Dockerfile:
FROM debian:bullseye

# Installer PHP-FPM et extensions nécessaires
RUN apt-get update && apt-get install -y \
    php7.4-fpm \
    php7.4-mysql \
    php7.4-gd \
    php7.4-xml \
    php7.4-curl \
    curl wget \
    && rm -rf /var/lib/apt/lists/*

# Installer WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Créer dossiers et permissions
RUN mkdir -p /run/php /var/www/html \
    && chown -R www-data:www-data /var/www/html /run/php

WORKDIR /var/www/html

# Télécharger et installer WordPress
RUN curl -O https://wordpress.org/latest.tar.gz && \
    tar -xvzf latest.tar.gz --strip-components=1 && \
    rm latest.tar.gz

COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY ./tools/auto-install.sh /auto-install.sh

RUN chown -R www-data:www-data /var/www/html && \
    chmod +x /auto-install.sh

EXPOSE 9000

# Lancer le script d'installation WordPress
CMD ["/auto-install.sh"]


.env:

DOMAIN_NAME=rhanitra.42.fr

MYSQL_DATABASE=wordpress
MYSQL_USER=wordpress_user


WORDPRESS_DB_HOST=mariadb
WORDPRESS_DB_NAME=wordpress
WORDPRESS_DB_USER=wordpress_user
WORDPRESS_URL=https://rhanitra.42.fr
WORDPRESS_TITLE=Inception WordPress Site
WORDPRESS_ADMIN_USER=rivo
WORDPRESS_ADMIN_EMAIL=admin@localhost.com
WORDPRESS_USER_EMAIL=user@localhost.com

docker-compose.yml:
version: '3.8'

services:
  mariadb:
    build: ./requirements/mariadb
    image: mariadb:inception
    container_name: mariadb
    restart: always
    ports:
      - "3306:3306"
    env_file:
      - .env
    environment:
      MYSQL_ROOT_PASSWORD: /run/secrets/MYSQL_ROOT_PASSWORD
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: /run/secrets/MYSQL_PASSWORD
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-uroot", "-p$(cat /run/secrets/MYSQL_ROOT_PASSWORD)"]
      interval: 10s
      timeout: 5s
      retries: 5

    volumes:
      - db_data:/var/lib/mysql
    secrets:
      - MYSQL_ROOT_PASSWORD
      - MYSQL_PASSWORD
    networks:
      - inception-network

  wordpress:
    build: ./requirements/wordpress
    image: wordpress:inception
    container_name: wordpress
    restart: always
    ports:
      - "9000:9000"
    depends_on:
      mariadb:
        condition: service_healthy
    env_file:
      - .env
    environment:
      WORDPRESS_DB_HOST: ${WORDPRESS_DB_HOST}
      WORDPRESS_DB_NAME: ${WORDPRESS_DB_NAME}
      WORDPRESS_DB_USER: ${WORDPRESS_DB_USER}
      WORDPRESS_DB_PASSWORD: /run/secrets/WORDPRESS_DB_PASSWORD
    volumes:
      - wp_data:/var/www/html
    secrets:
      - WORDPRESS_DB_PASSWORD
      - WORDPRESS_USER_PASSWORD
      - WORDPRESS_ADMIN_PASSWORD
    networks:
      - inception-network

  nginx:
    build: ./requirements/nginx
    image: nginx:inception
    container_name: nginx
    restart: always
    depends_on:
      - wordpress
    ports:
      - "443:443"
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.nginx.rule=Host(`rhanitra.42.fr`)"
    volumes:
      - wp_data:/var/www/html
      - ./requirements/nginx/conf/default.conf:/etc/nginx/conf.d/default.conf
      - ../secrets/certs:/etc/ssl/private/
    networks:
      - inception-network

volumes:
  db_data:
    driver: local
  wp_data:
    driver: local

networks:
  inception-network:
    driver: bridge

secrets:
  MYSQL_ROOT_PASSWORD:
    file: ../secrets/MYSQL_ROOT_PASSWORD.txt
  MYSQL_PASSWORD:
    file: ../secrets/MYSQL_PASSWORD.txt
  WORDPRESS_DB_PASSWORD:
    file: ../secrets/WORDPRESS_DB_PASSWORD.txt
  WORDPRESS_ADMIN_PASSWORD:
    file: ../secrets/WORDPRESS_ADMIN_PASSWORD.txt
  WORDPRESS_USER_PASSWORD:
    file: ../secrets/WORDPRESS_USER_PASSWORD.txt
Makefile:

NAME = inception

COMPOSE = docker compose
COMPOSE_FILE = -f ./srcs/docker-compose.yml
ENV_FILE = --env-file srcs/.env

DOMAIN=rhanitra.42.fr


all: up addHost

up:
	$(COMPOSE) $(ENV_FILE) $(COMPOSE_FILE) up --build -d

build:
	$(COMPOSE) $(ENV_FILE) $(COMPOSE_FILE) build

down:
	$(COMPOSE) $(COMPOSE_FILE) down

logs:
	$(COMPOSE) $(COMPOSE_FILE) logs -f

start:
	$(COMPOSE) $(COMPOSE_FILE) start

stop:
	$(COMPOSE) $(COMPOSE_FILE) stop

ps:
	$(COMPOSE) $(COMPOSE_FILE) ps

exec:
	$(COMPOSE) $(COMPOSE_FILE) exec

addHost:
	@echo "Add host $(DOMAIN)"
	@grep -qxF "127.0.0.1 $(DOMAIN)" /etc/hosts || \
		echo "127.0.0.1 $(DOMAIN)" | sudo tee -a /etc/hosts

rmHost:
	@echo "Remove host $(DOMAIN)"
	@sudo sed -i '\|127.0.0.1[[:space:]]\+$(DOMAIN)|d' /etc/hosts

fclean: down
	docker system prune -af
# 	sudo rm -rf /home/rhanitra/data/*

re: fclean all

.PHONY: all up build down logs start stop ps exec fclean re

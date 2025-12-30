#!/bin/bash
set -e

if [ -z "$(ls -A /var/www/html)" ]; then
    echo "[INFO] Downloading WordPress..."
    curl -O https://wordpress.org/latest.tar.gz
    tar -xvzf latest.tar.gz --strip-components=1
    rm latest.tar.gz
    chown -R www-data:www-data /var/www/html
fi

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

    echo "[INFO] user creation ${WORDPRESS_USER}..."
    if ! wp user create "${WORDPRESS_USER}" "${WORDPRESS_USER_EMAIL}" \
        --user_pass="$(cat /run/secrets/WORDPRESS_USER_PASSWORD)" \
        --role=subscriber \
        --allow-root; then
        echo "[WARNING] User creation failed or already exist"
    fi


    wp theme install twentytwentythree --activate --allow-root

    echo "[INFO] WordPress installation completed!"
else
    echo "[INFO] WordPress is already installed!"
fi

exec php-fpm7.4 -F
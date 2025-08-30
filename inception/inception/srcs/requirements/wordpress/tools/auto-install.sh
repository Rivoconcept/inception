#!/bin/bash
set -e

# --- Créer wp-config.php via WP-CLI ---
echo "[INFO] Creating wp-config.php..."
wp config create \
    --dbname="$WORDPRESS_DB_NAME" \
    --dbuser="$WORDPRESS_DB_USER" \
    --dbpass="$(cat /run/secrets/WORDPRESS_DB_PASSWORD)" \
    --dbhost="$WORDPRESS_DB_HOST" \
    --force \
    --allow-root

# --- Installation de WordPress via WP-CLI ---
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

    # Création du compte utilisateur normal
    wp user create "${WORDPRESS_USER}" "${WORDPRESS_USER_EMAIL}" \
        --user_pass="$(cat /run/secrets/WORDPRESS_USER_PASSWORD)" \
        --role=subscriber \
        --allow-root

    # Optionnel : installer et activer un thème
    wp theme install twentytwentythree --activate --allow-root

    echo "[INFO] WordPress installation completed!"
else
    echo "[INFO] WordPress is already installed!"
fi

# --- Lancer PHP-FPM comme processus principal ---
export WORDPRESS_DB_PASSWORD="$(cat /run/secrets/WORDPRESS_DB_PASSWORD)"
exec php-fpm7.4 -F

#!/bin/bash


# Attente de MariaDB si nécessaire
until mysql -h mariadb -u wordpress -p"$(cat /run/secrets/dbpass)" -e "SELECT 1" >/dev/null 2>&1; do
    echo "MariaDB n'est pas prête, attente..."
    sleep 2
done

# Créer wp-config.php avec secrets
wp config create \
  --dbname=wordpress \
  --dbuser=wordpress \
  --dbpass="$(cat /run/secrets/dbpass)" \
  --dbhost=mariadb \
  --allow-root

if ! wp core is-installed --allow-root; then
    echo "Installing WordPress..."
    
    # Install WordPress core
    wp core install \
        --url=${WORDPRESS_URL} \
        --title="${WORDPRESS_TITLE}" \
        --admin_user=${WORDPRESS_ADMIN_USER} \
        --admin_password=$(cat /run/secrets/wppassadmin) \
        --admin_email=${WORDPRESS_ADMIN_EMAIL} \
        --skip-email \
        --allow-root
    
    # Install and activate a theme (optional)
    wp theme install twentytwentythree --activate --allow-root
    
    echo "WordPress installation completed!"
else
    echo "WordPress is already installed!"
fi

    wp user create ${WORDPRESS_USER} ${WORDPRESS_USER_EMAIL} \
        --user_pass=$(cat /run/secrets/wppassuser) \
        --allow-root

# Start PHP-FPM
exec php-fpm7.4 -F 
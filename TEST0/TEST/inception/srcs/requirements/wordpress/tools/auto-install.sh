#!/bin/bash

 wp config create
    --dbname=${WORDPRESS_DB_NAME} \
    --dbuser=${WORDPRESS_DB_USER} \
    --dbpass=$(cat /run/secrets/dbpass) \
    --dbhost=${WORDPRESS_DB_HOST} \
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
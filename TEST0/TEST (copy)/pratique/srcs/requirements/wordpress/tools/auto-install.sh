#!/bin/bash

# Wait for MariaDB to be ready
echo "Waiting for MariaDB to be ready..."
while ! mysql -h mariadb -u ${WORDPRESS_DB_USER} -p${WORDPRESS_DB_PASSWORD} -e "SELECT 1" >/dev/null 2>&1; do
    sleep 2
done

echo "MariaDB is ready!"

# Check if WordPress is already installed
if ! wp core is-installed --allow-root; then
    echo "Installing WordPress..."
    
    # Install WordPress core
    wp core install \
        --url=${WORDPRESS_URL} \
        --title="${WORDPRESS_TITLE}" \
        --admin_user=${WORDPRESS_ADMIN_USER} \
        --admin_password=${WORDPRESS_ADMIN_PASSWORD} \
        --admin_email=${WORDPRESS_ADMIN_EMAIL} \
        --skip-email \
        --allow-root
    
    # Install and activate a theme (optional)
    wp theme install twentytwentythree --activate --allow-root
    
    echo "WordPress installation completed!"
else
    echo "WordPress is already installed!"
fi

# Start PHP-FPM
exec php-fpm7.4 -F 
#!/bin/bash

# Generate SSL certificates if they don't exist
if [ ! -f /etc/ssl/certs/nginx.crt ] || [ ! -f /etc/ssl/private/nginx.key ]; then
    echo "Generating SSL certificates..."
    mkdir -p /etc/ssl/certs /etc/ssl/private
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/ssl/private/nginx.key \
        -out /etc/ssl/certs/nginx.crt \
        -subj "/C=FR/ST=France/L=Paris/O=42/OU=Inception/CN=rhanitra.42.fr"
    chmod 644 /etc/ssl/certs/nginx.crt
    chmod 600 /etc/ssl/private/nginx.key
fi

# Wait for WordPress to be ready
echo "Waiting for WordPress to be ready..."
while ! nc -z wordpress 9000; do
  sleep 1
done

echo "WordPress is ready, starting Nginx..."
nginx -g "daemon off;" 
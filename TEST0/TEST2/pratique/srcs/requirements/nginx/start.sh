#!/bin/bash

CERT_DIR="/etc/ssl/private"
CRT_FILE="$CERT_DIR/nginx.crt"
KEY_FILE="$CERT_DIR/nginx.key"

# Générer le certificat si absent
if [ ! -f "$CRT_FILE" ] || [ ! -f "$KEY_FILE" ]; then
    echo "Generating SSL certificates..."
    mkdir -p $CERT_DIR
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout "$KEY_FILE" \
        -out "$CRT_FILE" \
        -subj "/C=FR/ST=France/L=Paris/O=42/OU=Inception/CN=rhanitra.42.fr"
    chmod 644 "$CRT_FILE"
    chmod 600 "$KEY_FILE"
fi

# Attente que WordPress (php-fpm) réponde
echo "Waiting for WordPress to be ready..."
while ! nc -z wordpress 9000; do
  sleep 1
done

echo "WordPress is ready, starting Nginx..."
nginx -g "daemon off;"

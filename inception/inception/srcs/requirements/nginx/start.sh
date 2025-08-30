#!/bin/bash
set -e

CERT_DIR="/etc/ssl/private"
CRT_FILE="$CERT_DIR/nginx.crt"
KEY_FILE="$CERT_DIR/nginx.key"

# Générer le certificat SSL si absent
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
# Lancer NGINX en mode foreground (daemon off)
nginx -g "daemon off;"

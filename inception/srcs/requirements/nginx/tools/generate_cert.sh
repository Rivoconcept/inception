#!/bin/bash

mkdir -p /etc/nginx/ssl

openssl req -x509 -nodes -days 365 \
  -subj "/C=FR/ST=Antananarivo/L=Antananarivo/O=42/Inception/CN=login.42.fr" \
  -newkey rsa:2048 \
  -keyout /etc/nginx/ssl/nginx.key \
  -out /etc/nginx/ssl/nginx.crt

echo "Certificat auto-signé généré dans /etc/nginx/ssl/"

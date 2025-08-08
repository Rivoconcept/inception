#!/bin/bash

# Générer le certificat TLS si non existant
if [ ! -f /etc/nginx/ssl/nginx.key ] || [ ! -f /etc/nginx/ssl/nginx.crt ]; then
    echo "Génération du certificat TLS auto-signé..."
    /generate_cert.sh
else
    echo "Certificat TLS déjà existant, génération ignorée."
fi

# Lancer nginx ou la commande passée
exec "$@"

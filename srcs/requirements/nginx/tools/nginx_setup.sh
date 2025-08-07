#!/bin/bash

# Ajouter la ligne dans /etc/hosts s'il n'existe pas déjà
# if ! grep -q "127.0.0.1 rhanitra.42.fr" /etc/hosts; then
#     echo "Ajout de rhanitra.42.fr à /etc/hosts"
#     echo "127.0.0.1 rhanitra.42.fr" >> /etc/hosts
# else
#     echo "L'entrée /etc/hosts existe déjà."
# fi

# Générer le certificat TLS si non existant
if [ ! -f /etc/nginx/ssl/nginx.key ] || [ ! -f /etc/nginx/ssl/nginx.crt ]; then
    echo "Génération du certificat TLS auto-signé..."
    /generate_cert.sh
else
    echo "Certificat TLS déjà existant, génération ignorée."
fi

# Lancer nginx ou la commande passée
exec "$@"

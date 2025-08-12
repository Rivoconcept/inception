FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Copie les scripts
COPY ./tools/generate_cert.sh /generate_cert.sh
COPY ./tools/nginx_setup.sh /nginx_setup.sh

# Copie la config nginx
COPY ./conf/default.conf /etc/nginx/sites-available/default

# Rends les scripts exécutables
RUN chmod +x /generate_cert.sh /nginx_setup.sh

# Ne génère pas le certificat au build, il sera généré au lancement
# (supprime la ligne RUN /generate_cert.sh)

# Expose le port 443 pour HTTPS
EXPOSE 443

# Exécute le script de configuration TLS et NGINX

ENTRYPOINT ["/nginx_setup.sh"]
CMD ["nginx", "-g", "daemon off;"]






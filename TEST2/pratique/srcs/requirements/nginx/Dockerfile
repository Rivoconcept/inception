FROM debian:bullseye-slim

ARG DEBIAN_FRONTEND=noninteractive
ARG DOMAIN=rhanitra.42.fr

RUN apt-get update && \
    apt-get install -y nginx openssl gettext-base && \
    rm -rf /var/lib/apt/lists/*

# Generate SSL certs
RUN mkdir -p /etc/ssl/certs && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/certs/key.pem \
    -out /etc/ssl/certs/cert.pem \
    -subj "/CN=${DOMAIN}" && \
    chmod 600 /etc/ssl/certs/key.pem

# Copy and process configuration
COPY /conf/default.conf /etc/nginx/conf.d/default.conf

# Process environment variables in config
RUN envsubst '${DOMAIN}' < /etc/nginx/conf.d/default.conf > /etc/nginx/conf.d/default.conf.tmp && \
    mv /etc/nginx/conf.d/default.conf.tmp /etc/nginx/conf.d/default.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
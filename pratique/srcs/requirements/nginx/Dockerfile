FROM debian:bullseye-slim

ARG DEBIAN_FRONTEND=noninteractive
ARG DOMAIN=localhost
ARG TLS_VERSION=TLSv1.3

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

# Copy and process files
COPY conf/nginx.conf /etc/nginx/conf.d/default.conf.template
COPY dist/ /usr/share/nginx/html/

# Set permissions
RUN chown -R www-data:www-data /usr/share/nginx/html && \
    chmod -R 755 /usr/share/nginx/html && \
    envsubst '${DOMAIN} ${TLS_VERSION}' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf && \
    envsubst '${DOMAIN} ${TLS_VERSION}' < /usr/share/nginx/html/index.html > /usr/share/nginx/html/index.html.processed && \
    mv /usr/share/nginx/html/index.html.processed /usr/share/nginx/html/index.html

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
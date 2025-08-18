FROM debian:bullseye-slim

ARG DEBIAN_FRONTEND=noninteractive
ARG DOMAIN=rhanitra.42.fr
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
    chmod 644 /etc/ssl/certs/cert.pem && \
    chmod 600 /etc/ssl/certs/key.pem

# Copy and process files
COPY /conf/default.conf /etc/nginx/conf.d/default.conf
COPY /dist/ /usr/share/nginx/html/

# Set permissions and substitute variables
RUN chmod -R 755 /usr/share/nginx/html && \
    if [ -z "${DOMAIN}" ]; then echo "ERROR: DOMAIN is not set" && exit 1; fi && \
    envsubst '${DOMAIN} ${TLS_VERSION}' < /etc/nginx/conf.d/default.conf > /etc/nginx/conf.d/default.conf.tmp && \
    mv /etc/nginx/conf.d/default.conf.tmp /etc/nginx/conf.d/default.conf && \
    envsubst '${DOMAIN} ${TLS_VERSION}' < /usr/share/nginx/html/index.html > /usr/share/nginx/html/index.html.processed && \
    mv /usr/share/nginx/html/index.html.processed /usr/share/nginx/html/index.html && \
    nginx -t

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
# FROM debian:bullseye-slim

# RUN apt-get update && apt-get install -y --no-install-recommends nginx openssl \
#     && rm -rf /var/lib/apt/lists/*

# RUN mkdir -p /etc/nginx/ssl \
#     && openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
#         -keyout /etc/nginx/ssl/nginx.key \
#         -out /etc/nginx/ssl/nginx.crt \
#         -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=rhanitra.42.fr"

# COPY conf/default.conf /etc/nginx/conf.d/default.conf

# EXPOSE 443

# CMD ["nginx", "-g", "daemon off;"]

FROM debian:bullseye

RUN apt-get update && apt-get install -y nginx openssl && rm -rf /var/lib/apt/lists/*

COPY ./conf/default.conf /etc/nginx/conf.d/default.conf

# SSL self-signed
RUN mkdir -p /etc/ssl/certs /etc/ssl/private && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/nginx.key \
    -out /etc/ssl/certs/nginx.crt \
    -subj "/C=FR/ST=France/L=Paris/O=42/OU=Inception/CN=localhost"

CMD ["nginx", "-g", "daemon off;"]

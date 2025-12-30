FROM debian:bullseye

RUN apt-get update && apt-get install -y nginx openssl netcat && rm -rf /var/lib/apt/lists/*

COPY ./conf/default.conf /etc/nginx/conf.d/default.conf

COPY ./start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]

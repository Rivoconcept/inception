FROM debian:bullseye-slim

LABEL app="mynginx" \
      version="v1.0.0" \
      description="Custom server nginx for inception"

ENV NGINX_PORT=8080 \
    NGINX_DOC_ROOT=/usr/share/nginx/html

RUN apt-get update && apt-get install -y nginx \
    && rm -rf /var/lib/apt/lists/*

ARG UID=1000
ARG GID=1000

RUN addgroup --gid $GID mygroup \
    && adduser --disabled-password --gecos "" --uid $UID --gid $GID rhanitra


WORKDIR $NGINX_DOC_ROOT

RUN rm -rf ./* \
    && mkdir -p /usr/share/nginx/html /var/run/nginx /var/log/nginx \
    && chown -R rhanitra:mygroup /usr/share/nginx/html /var/run/nginx /var/log/nginx
    
COPY --chown=rhanitra:mygroup . .

COPY --chown=rhanitra:mygroup /conf/default.conf /etc/nginx/conf.d/default.conf

USER rhanitra

EXPOSE $NGINX_PORT

CMD ["nginx", "-g", "daemon off;"]


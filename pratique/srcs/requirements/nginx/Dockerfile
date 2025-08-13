FROM debian:bullseye-slim

ARG UID=1000
ARG GID=1000
RUN addgroup -g $GID mygroup && \
    adduser -D -u $UID -G mygroup rhanitra

WORKDIR /usr/share/nginx/html

RUN rm -rf ./*


COPY ./dist/ .

COPY ./nginx.conf /etc/nginx/nginx.conf

RUN chown -R rhanitra:mygroup /usr/share/nginx/html

USER rhanitra

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

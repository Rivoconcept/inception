# FROM debian:bullseye-slim

# LABEL maintainer="rhanitra.42.fr"

# RUN apt-get update && apt-get install -y \
#     mariadb-server \
#     && rm -rf /var/lib/apt/lists/*

# RUN mkdir -p /var/lib/mysql /var/run/mysqld \
#     && chown -R mysql:mysql /var/lib/mysql /var/run/mysqld

# VOLUME ["/var/lib/mysql"]

# COPY ./tools/init.sh /docker-entrypoint.sh
# RUN chmod +x /docker-entrypoint.sh

# EXPOSE 3306

# CMD ["/docker-entrypoint.sh"]


FROM debian:bullseye

RUN apt-get update && apt-get install -y mariadb-server && rm -rf /var/lib/apt/lists/*

COPY ./conf/my.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY ./tools/init.sh /init.sh
RUN chmod +x /init.sh

CMD ["/init.sh"]

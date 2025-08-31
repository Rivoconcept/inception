#!/bin/bash
set -e

ROOT_PASS=$(cat /run/secrets/dbrootpass)
USER_PASS=$(cat /run/secrets/dbpass)

# Initialisation uniquement si /var/lib/mysql vide
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "[INFO] Initializing MariaDB..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql

    exec mariadbd --user=mysql \
        --datadir=/var/lib/mysql \
        --init-file=<(echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '$ROOT_PASS'; \ 
        CREATE DATABASE IF NOT EXISTS wordpress; CREATE USER 'wordpress'@'%' \
        IDENTIFIED BY '$USER_PASS'; GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'%'; FLUSH PRIVILEGES;")
else
    exec mariadbd --user=mysql --datadir=/var/lib/mysql
fi




# #!/bin/bash
# set -e

# if [ ! -d "/var/lib/mysql/mysql" ]; then
#     echo "[i] Initialisation de MariaDB..."
#     mysql_install_db --user=mysql --datadir=/var/lib/mysql

#     mysqld --user=mysql &
#     pid="$!"

#     until mysqladmin ping >/dev/null 2>&1; do
#         sleep 1
#     done

#     mysql -u root <<-EOSQL
#         CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
#         CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
#         GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
#         ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
#         FLUSH PRIVILEGES;
# EOSQL

#     kill "$pid"
#     wait "$pid"
#     echo "[i] Initialisation terminée."
# fi

# exec mysqld --user=mysql



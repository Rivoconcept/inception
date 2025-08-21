#!/bin/bash
set -e

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "[INFO] Initializing MariaDB..."
    mysqld --initialize-insecure --user=mysql --datadir=/var/lib/mysql

    mysqld_safe --datadir=/var/lib/mysql &

    until mysqladmin ping >/dev/null 2>&1; do
        sleep 1
    done

    echo "[INFO] Creating database and user..."
    mysql -uroot <<EOF
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

    mysqladmin -uroot -p${MYSQL_ROOT_PASSWORD} shutdown
fi

exec mysqld_safe --datadir=/var/lib/mysql



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



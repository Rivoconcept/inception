#!/bin/bash
set -e

if [ ! -d "/var/lib/mysql/mysql" ] || [ ! -f "/var/lib/mysql/.initialized" ]; then
    echo "[INFO] Initializing MariaDB..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    mysqld_safe --datadir=/var/lib/mysql &

    until mysqladmin ping >/dev/null 2>&1; do
        sleep 1
    done

    echo "[INFO] Creating database and user..."
    mysql -uroot <<EOF
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '$(cat /run/secrets/MYSQL_PASSWORD)';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '$(cat /run/secrets/MYSQL_ROOT_PASSWORD)';
FLUSH PRIVILEGES;
EOF

    mysqladmin -uroot -p$(cat /run/secrets/MYSQL_ROOT_PASSWORD) shutdown
    

    touch /var/lib/mysql/.initialized
fi

exec mysqld_safe --datadir=/var/lib/mysql



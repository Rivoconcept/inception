#!/bin/bash
set -e

DATA_DIR="/var/lib/mysql"

mkdir -p /var/run/mysqld
chown -R mysql:mysql /var/run/mysqld

if [ ! -d "$DATA_DIR/mysql" ]; then
    echo "[INFO] Initializing MariaDB..."
    
    mysql_install_db --user=mysql --datadir="$DATA_DIR" --skip-test-db
    
    mysqld --datadir="$DATA_DIR" --socket=/var/run/mysqld/mysqld.sock &
    MYSQL_PID=$!
    
    for i in {1..30}; do
        if mysql -uroot -S /var/run/mysqld/mysqld.sock -e "SELECT 1" >/dev/null 2>&1; then
            break
        fi
        sleep 1
    done
    
        mysql -uroot -S /var/run/mysqld/mysqld.sock <<EOF
    CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
    CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '$(cat /run/secrets/MYSQL_PASSWORD)';
    GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
    ALTER USER 'root'@'localhost' IDENTIFIED BY '$(cat /run/secrets/MYSQL_ROOT_PASSWORD)';
    CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '$(cat /run/secrets/MYSQL_ROOT_PASSWORD)';
    GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
    FLUSH PRIVILEGES;
EOF

    kill $MYSQL_PID
    wait $MYSQL_PID
    echo "[INFO] MariaDB initialized!"
fi

exec mysqld --datadir="$DATA_DIR"
#!/bin/bash
set -e

DATA_DIR="/var/lib/mysql"

mkdir -p /var/run/mysqld
chown -R mysql:mysql /var/run/mysqld

if [ ! -d "$DATA_DIR/mysql" ] || [ ! -f "$DATA_DIR/.initialized" ]; then
    echo "[INFO] Initializing MariaDB..."

    mysqld --initialize-insecure --user=mysql --datadir="$DATA_DIR"

    INIT_SQL="/tmp/init.sql"
    cat > "$INIT_SQL" <<EOF
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '$(cat /run/secrets/MYSQL_PASSWORD)';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '$(cat /run/secrets/MYSQL_ROOT_PASSWORD)';
FLUSH PRIVILEGES;
EOF

    mysqld --datadir="$DATA_DIR" --init-file="$INIT_SQL" &
    PID=$!
    wait $PID

    touch "$DATA_DIR/.initialized"
    echo "[INFO] MariaDB initialized!"
fi

exec mysqld --datadir="$DATA_DIR"

#!/bin/bash
set -e

DATA_DIR="/var/lib/mysql"

# S'assurer que le répertoire du socket existe
mkdir -p /var/run/mysqld
chown -R mysql:mysql /var/run/mysqld

# Initialisation si pas encore fait
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

# Démarrage normal
exec mysqld --datadir="$DATA_DIR"




# #!/bin/bash
# set -e

# if [ ! -d "/var/lib/mysql/mysql" ] || [ ! -f "/var/lib/mysql/.initialized" ]; then
#     echo "[INFO] Initializing MariaDB..."
#     mysql_install_db --user=mysql --datadir=/var/lib/mysql

#     mysqld_safe --datadir=/var/lib/mysql &

#     until mysqladmin ping >/dev/null 2>&1; do
#         sleep 1
#     done

#     echo "[INFO] Creating database and user..."
#     mysql -uroot <<EOF
# CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
# CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '$(cat /run/secrets/MYSQL_PASSWORD)';
# GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
# ALTER USER 'root'@'localhost' IDENTIFIED BY '$(cat /run/secrets/MYSQL_ROOT_PASSWORD)';
# FLUSH PRIVILEGES;
# EOF

#     mysqladmin -uroot -p$(cat /run/secrets/MYSQL_ROOT_PASSWORD) shutdown

#     touch /var/lib/mysql/.initialized
# fi

# exec mysqld_safe --datadir=/var/lib/mysql

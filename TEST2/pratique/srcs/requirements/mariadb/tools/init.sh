#!/bin/bash
set -e

DATADIR="/var/lib/mysql"

# Initialisation du datadir si vide
if [ ! -d "$DATADIR/mysql" ]; then
    echo "[i] Initialisation de MariaDB..."
    
    # Initialisation insecure pour root sans mot de passe temporaire
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql

    # Démarrage temporaire du serveur en arrière-plan
    mysqld --user=mysql --datadir="$DATADIR" &
    pid="$!"

    # Attendre que MariaDB soit prêt
    until mysqladmin ping >/dev/null 2>&1; do
        sleep 1
    done

    # Création base, utilisateur et mot de passe root
    mysql -u root <<-EOSQL
        CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
        CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
        GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
        FLUSH PRIVILEGES;
EOSQL

    # Arrêt du serveur temporaire
    kill "$pid"
    wait "$pid"
    echo "[i] Initialisation terminée."
fi

# Lancement final du serveur MariaDB
exec mysqld --user=mysql --datadir="$DATADIR"

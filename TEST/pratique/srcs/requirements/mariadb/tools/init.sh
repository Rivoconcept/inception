#!/bin/bash
set -e

# Initialize MySQL data directory
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    # Start MySQL in the background
    mysqld --user=mysql &
    pid="$!"

    # Wait for MySQL to start
    until mysqladmin ping >/dev/null 2>&1; do
        sleep 1
    done

    # Initialize database
    mysql -u root << EOF
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

    # Stop MySQL
    kill "$pid"
    wait "$pid"
fi

# Start MySQL
exec mysqld --user=mysql

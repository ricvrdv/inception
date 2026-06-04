#!/bin/bash

DB_PASSWORD=$(cat /run/secrets/db_password)
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

if [ ! -d /var/lib/mysql/mysql ]; then
	mysql_install_db --user=mysql --datadir=/var/lib/mysql
	mysqld_safe --user=mysql &
	until mysqladmin ping --silent; do
		sleep 1
	done
	mysql -u root << EOF
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

	mysqladmin -u root -p"${DB_ROOT_PASSWORD}" shutdown
	
	until ! mysqladmin ping --silent; do
		sleep 1
	done
fi

exec mysqld_safe --user=mysql

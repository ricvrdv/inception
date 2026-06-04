#!/bin/bash

set -e

DB_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)

WP_PATH="/var/www/html/wordpress"

if [ ! -f "/usr/local/bin/wp" ]; then
	curl -s -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod +x /usr/local/bin/wp
fi

if [ ! -f "$WP_PATH/wp-config.php" ]; then
	until mariadb-admin ping -h "$DB_HOST" --silent; do sleep 2; done
	wp core download --path="$WP_PATH" --allow-root
	wp config create \
		--path="$WP_PATH" \
		--dbname="${DB_NAME}" \
		--dbuser="${DB_USER}" \
		--dbpass="${DB_PASSWORD}" \
		--dbhost="${DB_HOST}" \
		--allow-root
			
	wp core install \
		--path="$WP_PATH" \
		--url="${DOMAIN_NAME}" \
		--title="${WP_TITLE}" \
		--admin_user="${WP_ADMIN}" \
		--admin_password="${WP_ADMIN_PASSWORD}" \
		--admin_email="${WP_ADMIN_EMAIL}" \
		--allow-root
			
	wp user create \
		"${WP_USER}" \
		"${WP_USER_EMAIL}" \
		--role=author \
		--user_pass="${WP_USER_PASSWORD}" \
		--path="$WP_PATH" \
		--allow-root
			
	chown -R www-data:www-data /var/www/html
fi

mkdir -p /run/php
exec /usr/sbin/php-fpm8.2 -F

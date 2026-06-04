#!/bin/bash

set -e

DB_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)

WP_PATH="/var/www/html/wordpress"

mkdir -p /var/www/html

if [ ! -f "$WP_PATH/wp-config.php" ]; then

    echo "WordPress is not configured. Starting installation process..."

    if [ ! -f "/tmp/wordpress.tar.gz" ]; then
	    wget --tries=10 --retry-connrefused --waitretry=3 --continue \
		    -O /tmp/wordpress.tar.gz https://wordpress.org/latest.tar.gz
    fi
    
    tar -xzf /tmp/wordpress.tar.gz -C /var/www/html
    rm -f /tmp/wordpress.tar.gz

    if [ ! -f "/usr/local/bin/wp" ]; then
	    wget --tries=5 --retry-connrefused --waitretry=2 \
		    -O /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod +x /usr/local/bin/wp
    fi

    echo "Waiting for MariaDB at ${DB_HOST} to be ready..."
    until mariadb-admin ping -h "${DB_HOST}" --silent; do
	    sleep 3
    done
    echo "MariaDB is ready. Generating wp-config.php..."

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
    echo "WordPress installation and configuration completed successfully!"
else
	echo "WordPress is already isntalled and configured."
fi

mkdir -p /run/php
echo "Starting PHP-FPM..."
exec /usr/sbin/php-fpm8.2 -F

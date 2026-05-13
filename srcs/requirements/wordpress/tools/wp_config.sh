#!/bin/sh

while ! mariadb-admin ping -h"mariadb" --silent; do
    sleep 1;
done

FLAG="/var/www/html/wordpress/.flag"
WP="/var/www/html/wordpress/wp-settings.php"

if [ ! -f "/var/www/html/wordpress/wp-config.php" ] || [ ! -f "$FLAG" ]; then
    wp core download --allow-root --path=/var/www/html/wordpress
    wp config create \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD" \
        --dbhost=mariadb:3306 --allow-root --path=/var/www/html/wordpress --force
    wp core install \
        --url="$DOMAIN_NAME" \
        --title="$SITE_TITLE" \
        --admin_user="$ADMIN_USER" \
        --admin_password="$ADMIN_PASSWORD" \
        --admin_email="$ADMIN_EMAIL" --allow-root --path=/var/www/html/wordpress
    wp user create "$USER_LOGIN" "$USER_EMAIL" --role=author --user_pass="$USER_PASS" --allow-root --path=/var/www/html/wordpress
    chown -R www-data:www-data /var/www/html/wordpress
    touch "$FLAG"
fi

mkdir -p /run/php
chown www-data:www-data /run/php

grep "listen =" /etc/php/8.2/fpm/pool.d/www.conf
echo "Launch PHP-FPM 8.2"

exec /usr/sbin/php-fpm8.2 -F -y /etc/php/8.2/fpm/php-fpm.conf

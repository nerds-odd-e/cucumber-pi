#!/bin/bash
set -e

WORDPRESS_VERSION=4.2.4
WORDPRESS_HOME={{ wordpress_wwwroot }}

WORDPRESS_DBHOST={{ wordpress_mysql_hostname }}
WORDPRESS_DBNAME={{ wordpress_mysql_database }}
WORDPRESS_DBUSER={{ wordpress_mysql_username }}
WORDPRESS_DBPASS={{ wordpress_mysql_password }}

WP_CLI_CMD=wp

source /etc/profile.d/wp-cli.sh

[[ -f $WORDPRESS_HOME/wp-config-sample.php ]] || $WP_CLI_CMD core download --force --path=${WORDPRESS_HOME} --locale=en_US --version=${WORDPRESS_VERSION}
rm -f $WORDPRESS_HOME/wp-config.php
$WP_CLI_CMD core config --dbname=${WORDPRESS_DBNAME} --dbuser=${WORDPRESS_DBUSER} --dbpass=${WORDPRESS_DBPASS} --dbhost=${WORDPRESS_DBHOST} --dbprefix=wp_ --dbcharset=utf8
$WP_CLI_CMD db drop --yes || true
$WP_CLI_CMD db create
$WP_CLI_CMD core install --url=http://wordpress.local --title="Specification By Example Workshop" --admin_user=odd-e --admin_password=s3cr3t --admin_email=chaifeng@odd-e.com

$WP_CLI_CMD plugin install wordpress-importer --activate

$WP_CLI_CMD theme activate twentyfourteen
$WP_CLI_CMD post delete 1 2
$WP_CLI_CMD import --authors=create "$(dirname "$0")/specificationbyexampleworkshop.wordpress.xml"

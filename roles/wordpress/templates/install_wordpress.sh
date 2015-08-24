#!/bin/bash
set -e

WORDPRESS_VERSION=4.2.4
WORDPRESS_HOME="{{ wordpress_wwwroot }}"

WORDPRESS_DBHOST="{{ wordpress_mysql_hostname }}"
WORDPRESS_DBNAME="{{ wordpress_mysql_database }}"
WORDPRESS_DBUSER="{{ wordpress_mysql_username }}"
WORDPRESS_DBPASS="{{ wordpress_mysql_password }}"

WP_CLI_CMD=wp

source /etc/profile.d/wp-cli.sh

echo "Install WordPress ..."

find "${WORDPRESS_HOME}" -mindepth 1 -delete

$WP_CLI_CMD core download --force --path=${WORDPRESS_HOME} --locale=en_US --version=${WORDPRESS_VERSION}
$WP_CLI_CMD core config --dbname=${WORDPRESS_DBNAME} --dbuser=${WORDPRESS_DBUSER} --dbpass=${WORDPRESS_DBPASS} --dbhost=${WORDPRESS_DBHOST} --dbprefix=wp_ --dbcharset=utf8
$WP_CLI_CMD db drop --yes || true
$WP_CLI_CMD db create
$WP_CLI_CMD core install --url=http://wordpress.local --title="Specification By Example Workshop" --admin_user=odd-e --admin_password=s3cr3t --admin_email=chaifeng@odd-e.com

$WP_CLI_CMD plugin install wordpress-importer --activate

$WP_CLI_CMD theme activate twentyfourteen
$WP_CLI_CMD post delete 1 2
$WP_CLI_CMD import --authors=create "$(dirname "$0")/specificationbyexampleworkshop.wordpress.xml"

echo "Update WordPress configration ..."

$WP_CLI_CMD core update-db
$WP_CLI_CMD plugin update --all || true
$WP_CLI_CMD theme  update --all || true

$WP_CLI_CMD plugin install disable-google-fonts --activate

$WP_CLI_CMD user create tom tom@chaifeng.com --role=editor --user_pass=s3cr3t --first_name=Tom
$WP_CLI_CMD user create mary mary@chaifeng.com --role=subscriber --user_pass=s3cr3t --first_name=Marry

$WP_CLI_CMD option update default_comment_status closed
$WP_CLI_CMD option update default_ping_status closed
$WP_CLI_CMD option update default_pingback_flag ''
$WP_CLI_CMD option update comment_registration  0
$WP_CLI_CMD option update comment_moderation    ''
$WP_CLI_CMD option update comment_whitelist     ''
$WP_CLI_CMD option update comments_notify   ''
$WP_CLI_CMD option update moderation_notify ''
$WP_CLI_CMD option update show_avatars      ''
$WP_CLI_CMD option update permalink_structure  "/%postname%/"
$WP_CLI_CMD post update 1 2 3 4 5 6 7 8 9 --comment_status=closed
$WP_CLI_CMD post update 1 2 3 4 5 6 7 8 9 --ping_status=closed

touch "${WORDPRESS_HOME}/odd-e.txt"

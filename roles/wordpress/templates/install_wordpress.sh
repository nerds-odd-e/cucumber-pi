#!/bin/bash
set -e

WORDPRESS_VERSION="{{ wordpress_version }}"
WORDPRESS_HOME="{{ wordpress_wwwroot }}"
{% if wordpress_url is defined %}
WORDPRESS_URL="{{ wordpress_url }}"
{% endif %}
WORDPRESS_URL="${WORDPRESS_URL:-http://$(hostname -f)}"

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
$WP_CLI_CMD core install --url="${WORDPRESS_URL}" --title="Specification By Example Workshop" --admin_user=odd-e --admin_password=s3cr3t --admin_email=chaifeng@odd-e.com

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
$WP_CLI_CMD user create mary mary@chaifeng.com --role=subscriber --user_pass=s3cr3t --first_name=Mary

/usr/bin/wordpress_reset_config.sh
/usr/bin/wordpress_switch_to_url "${WORDPRESS_URL}"

date > "{{ wordpress_wwwroot }}/wordpress_{{ wordpress_version }}.txt"

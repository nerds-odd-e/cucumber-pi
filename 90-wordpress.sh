#!/bin/bash
set -e

WORDPRESS_VERSION=4.2.2

WORDPRESS_HOME=/var/www
WORDPRESS_USER=pi
WORDPRESS_DBHOST=localhost
WORDPRESS_DBNAME=wordpress
WORDPRESS_DBUSER=wordpress
WORDPRESS_DBPASS=wordpress

echo "Install wp-cli ..."

WP_CLI_HOME=/opt/wp-cli
WP_CLI_CMD=$WP_CLI_HOME/wp
WP_CLI_CONFIG_PATH=$WP_CLI_HOME/config.yml

mkdir -p $WP_CLI_HOME
if [[ ! -e $WP_CLI_CMD ]]; then
    wget --quiet -O /tmp/wp https://raw.github.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    mv /tmp/wp $WP_CLI_CMD
    chmod +x $WP_CLI_CMD
fi

cat > $WP_CLI_CONFIG_PATH <<EOF
path: $WORDPRESS_HOME
color: false
core config:
    dbuser: root
    dbpass:
EOF

cat > /etc/profile.d/wp-cli.sh <<EOF
export WP_CLI_CONFIG_PATH=$WP_CLI_CONFIG_PATH
export PATH=$WP_CLI_HOME:\$PATH
EOF

pushd $(dirname $WORDPRESS_HOME)
echo "Delete old WordPress files ..."
[[ -f $WORDPRESS_HOME/index.php ]] && [[ -d .git ]] && git status --ignored -s wordpress | grep '^!!' | cut -d' ' -f2 | xargs -- rm -r

echo "Install WordPress ..."
su -lc /bin/bash $WORDPRESS_USER <<EOF
set -e
mkdir -p \$HOME/.wp-cli/cache/core
if [[ -f /vagrant/cache/en_US-${WORDPRESS_VERSION}.tar.gz ]]; then
  cp -n /vagrant/cache/en_US-${WORDPRESS_VERSION}.tar.gz \$HOME/.wp-cli/cache/core/
fi

[[ -f $WORDPRESS_HOME/wp-config-sample.php ]] || $WP_CLI_CMD core download --path=${WORDPRESS_HOME} --locale=en_US --version=${WORDPRESS_VERSION}
rm -f $WORDPRESS_HOME/wp-config.php
$WP_CLI_CMD core config --dbname=${WORDPRESS_DBNAME} --dbuser=${WORDPRESS_DBUSER} --dbpass=${WORDPRESS_DBPASS} --dbhost=${WORDPRESS_DBHOST} --dbprefix=wp_ --dbcharset=utf8
$WP_CLI_CMD db drop --yes || true
$WP_CLI_CMD db create
$WP_CLI_CMD core install --url=http://wordpress.local --title="Specification By Example Workshop" --admin_user=odd-e --admin_password=s3cr3t --admin_email=chaifeng@odd-e.com
if [[ -f /vagrant/cache/wordpress-importer-0.6.1.zip ]]; then
    $WP_CLI_CMD plugin install /vagrant/cache/wordpress-importer-0.6.1.zip --activate
else
    $WP_CLI_CMD plugin install wordpress-importer --activate
fi
$WP_CLI_CMD theme activate twentyfourteen
$WP_CLI_CMD post delete 1 2
$WP_CLI_CMD import --authors=create ${WORDPRESS_HOME}/specificationbyexampleworkshop.wordpress.xml
EOF

popd

echo "Setup Apache2 ..."
cp -f wordpress.conf /etc/apache2/sites-available/
a2dissite 000-default
a2ensite wordpress.conf
a2enmod rewrite
service apache2 restart


cat >> /etc/motd <<EOF
WordPress:
    URL: http://wordpress.local
    Username: odd-e
    Passowrd: s3cr3t

EOF

cat > /usr/bin/wordpress_set_url <<EOF
#!/bin/bash
set -ex

if [[ "0" != \$(id -u) ]]; then
    sudo \$0 "\$@"
    exit $?
fi

WORDPRESS_URL=\${1:-http://wordpress.local}

WP_CLI_OPTS='--allow-root --path=$WORDPRESS_HOME'

[[ "\$WORDPRESS_URL" == "\$($WP_CLI_CMD \$WP_CLI_OPTS option get siteurl)" ]] \
&& [[ "\$($WP_CLI_CMD \$WP_CLI_OPTS option get siteurl)" == "\$($WP_CLI_CMD \$WP_CLI_OPTS option get home)" ]] \
&& exit 0

echo "
set -e
$WP_CLI_CMD \$WP_CLI_OPTS option update siteurl '\$WORDPRESS_URL'
$WP_CLI_CMD \$WP_CLI_OPTS option update home    '\$WORDPRESS_URL'
" | su -lc /bin/bash $WORDPRESS_USER

sudo sed -i -e "/URL:/{a\ \ \ \ URL: \${WORDPRESS_URL}
;d}" /etc/motd
EOF

cat > /usr/bin/wordpress_switch_to_ip <<EOF
#!/bin/bash
set -ex

WORDPRESS_URL="http://\$(/sbin/ifconfig | fgrep 'inet addr' | fgrep -v 10.0.2 | fgrep -v 127.0.0 | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | head -1)/"

wordpress_set_url "\$WORDPRESS_URL"
EOF

cat > /usr/bin/wordpress_switch_to_url <<EOF
#!/bin/bash
set -ex

wordpress_set_url "http://\$(hostname -f)"
EOF

chmod +x /usr/bin/wordpress_*

su -lc /bin/bash $WORDPRESS_USER <<EOF
set -e
echo "Update WordPress configration ..."

/usr/bin/wordpress_switch_to_url

$WP_CLI_CMD core update-db
$WP_CLI_CMD plugin update --all || true
$WP_CLI_CMD theme  update --all || true

$WP_CLI_CMD user create tom tom@chaifeng.com --role=editor --user_pass=s3cr3t --first_name=Tom
$WP_CLI_CMD user create marry marry@chaifeng.com --role=subscriber --user_pass=s3cr3t --first_name=Marry

$WP_CLI_CMD option update siteurl '\$WORDPRESS_URL'
$WP_CLI_CMD option update home    '\$WORDPRESS_URL'
$WP_CLI_CMD option update default_comment_status closed
$WP_CLI_CMD option update default_ping_status closed
$WP_CLI_CMD option update default_pingback_flag ''
$WP_CLI_CMD option update comment_moderation    ''
$WP_CLI_CMD option update comment_whitelist     ''
$WP_CLI_CMD option update comments_notify   ''
$WP_CLI_CMD option update moderation_notify ''
$WP_CLI_CMD option update show_avatars      ''
$WP_CLI_CMD post update 1 6 7 8 9 --comment_status=closed
$WP_CLI_CMD post update 1 6 7 8 9 --ping_status=closed

EOF

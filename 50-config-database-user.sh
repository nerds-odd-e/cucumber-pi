#!/bin/bash
set -e

echo 'Create databases'

MYSQL_USERNAME=wordpress
MYSQL_PASSWORD=wordpress
MYSQL_DATABASE=wordpress

[[ -f /.mysql-user-created ]] || mysql -u root <<EOF
    CREATE USER '${MYSQL_USERNAME}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON * . * TO '${MYSQL_USERNAME}'@'%';
EOF
touch /.mysql-user-created

echo "DROP DATABASE IF EXISTS ${MYSQL_DATABASE};" | mysql -uroot
echo 'CREATE DATABASE /*!32312 IF NOT EXISTS*/' "\`${MYSQL_DATABASE}\`" '/*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_bin */;' | mysql -uroot

echo "Import data ..."
ls /vagrant/sql/*.sql 2>&1 1>/dev/null && for SQLFILE in /vagrant/sql/*.sql; do
    echo "  Importing ${SQLFILE} ..."
    mysql -u$MYSQL_USERNAME -p$MYSQL_PASSWORD $MYSQL_DATABASE < "$SQLFILE"
done

cat >> /etc/motd <<EOF
MySQL:
    Hostname: 127.0.0.1
    Username: ${MYSQL_USERNAME}
    Password: ${MYSQL_PASSWORD}
    Database: ${MYSQL_DATABASE}

EOF

#!/bin/bash
echo "Start installation from userdata ..." >> /var/log/bootstrap.log 2>&1
cd /tmp
wget https://gist.githubusercontent.com/3dw1np/a40c0e8b069dd1596dad544633a6f3d1/raw/ec93eb7453437def64262a369774877d655c7ad5/ubuntu_install.sh  >> /var/log/bootstrap.log 2>&1
chmod +x ubuntu_install.sh

export WORDPRESS_DB_HOSTNAME="${WORDPRESS_DB_HOSTNAME}"
export WORDPRESS_DB_NAME="${WORDPRESS_DB_NAME}"
export WORDPRESS_DB_USER="${WORDPRESS_DB_USER}"
export WORDPRESS_DB_PASSWORD="${WORDPRESS_DB_PASSWORD}"
export WORDPRESS_ADMIN_USER="${WORDPRESS_ADMIN_USER}"
export WORDPRESS_ADMIN_PASSWORD="${WORDPRESS_ADMIN_PASSWORD}"
export WORDPRESS_ADMIN_EMAIL="${WORDPRESS_ADMIN_EMAIL}"
export WORDPRESS_URL="${WORDPRESS_URL}"
export WORDPRESS_SITE_TITLE="${WORDPRESS_SITE_TITLE}"
export LETS_ENCRYPT_STAGING="${LETS_ENCRYPT_STAGING}"

./ubuntu_install.sh  >> /var/log/bootstrap.log 2>&1
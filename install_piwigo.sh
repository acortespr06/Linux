#!/bin/bash

# Update Server
apt update && apt upgrade -y

# Set hostname
hostnamectl set-hostname ex.example.com
echo "server_ip ex.example.com ex" >> /etc/hosts

# Install LAMP Server
apt install apache2 mariadb-server php libapache2-mod-php php-common php-mbstring php-xmlrpc php-gd php-xml php-intl php-mysql php-cli php php-ldap php-zip php-curl unzip git -y
sed -i 's/memory_limit = .*/memory_limit = 512M/' /etc/php/7.4/apache2/php.ini
sed -i 's/upload_max_filesize = .*/upload_max_filesize = 200M/' /etc/php/7.4/apache2/php.ini
echo "date.timezone = Asia/Kolkata" >> /etc/php/7.4/apache2/php.ini
systemctl restart apache2

# Create a Database for Piwigo
mysql <<EOF
CREATE DATABASE piwigo;
CREATE USER 'piwigo'@'localhost' IDENTIFIED BY '123Admin';
GRANT ALL ON piwigo.* TO 'piwigo'@'localhost' IDENTIFIED BY '123Admin' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EXIT;
EOF

# Install Piwigo
curl -o piwigo.zip http://piwigo.org/download/dlcounter....
unzip piwigo.zip
mv piwigo /var/www/html/piwigo
chown -R www-data:www-data /var/www/html/piwigo/
chmod -R 755 /var/www/html/piwigo/

# Change ownership of files in /var/www/html/piwigo/
chown -R www-data:www-data /var/www/html/piwigo/

# Configure Apache for Piwigo
cat <<EOL > /etc/apache2/sites-available/piwigo.conf
<VirtualHost *:80>
    ServerAdmin admin@example.com
    DocumentRoot /var/www/html/piwigo
    ServerName ex.example.com

    <Directory /var/www/html/piwigo/>
        Options +FollowSymlinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOL

a2ensite piwigo.conf
a2enmod rewrite
systemctl restart apache2

echo "Installation and configuration completed successfully."


#!/bin/bash
DBPASSWORD=$1
storage-account-name=$2
storage-acccount-key=$3
hostname=$4
adminuser=$5

sleep 180
sudo apt-get update -y
sudo apt-get install cifs-utils apache2 php libapache2-mod-php php-mcrypt php-mysql mysql-client -y
# Sustituir los valores de [storage-account-name] y [storage-account-key]
if [ ! -d "/etc/smbcredentials" ]; then
    sudo mkdir /etc/smbcredentials
fi

if [ ! -f "/etc/smbcredentials/$storage-account-name.cred" ]; then
    sudo bash -c 'echo "username=$storage-account-name" >> /etc/smbcredentials/$storage-account-name.cred'
    sudo bash -c 'echo "password=$storage-account-key" >> /etc/smbcredentials/$storage-account-name.cred'
fi
sudo chmod 600 /etc/smbcredentials/storage-account-name.cred
sudo bash -c 'echo "//$storage-account-name.file.core.windows.net/wp-content /var/www/html/wp-content cifs nofail,vers=3.0,credentials=/etc/smbcredentials/$storage-account-name.cred,dir_mode=0777,file_mode=0777,serverino" >> /etc/fstab'

# Copiar archivos del programa
if [ ! -f "/var/www/html/wp-content/index.php" ]; then
    sudo cp -r /deployTemp/drop/. /var/www/html/
fi

if [ -f "/var/www/html/wp-content/index.php" ]; then
    find /deployTemp/drop/. -mindepth 1 -maxdepth 1 -type d ! -regex '\(.*wp-content\)' -exec sudo cp -r {} /var/www/html/ \;
fi

sudo chown -R www-data.www-data /var/www/html
sudo chmod -R 775 /var/www/html

# Creamos la base de datos y el usuario que la usará
mysql -h $hostname.mysql.database.azure.com -u $adminuser@$hostname -p"$DBPASSWORD" -e "CREATE DATABASE wordpress; CREATE USER 'wordpress'@'%' IDENTIFIED BY '${DBPASSWORD}'; GRANT ALL PRIVILEGES ON wordpress . * TO 'wordpress'@'%'; FLUSH PRIVILEGES;"

# Insertamos la información en el archivo wp-config.php
sudo cp /var/www/html/script/wp-config.example.php /var/www/html/wp-config.php
sudo rm /var/www/html/index.html
sudo sed -i '25 a define( 'DB_USER', 'wordpress@$hostname' );' /var/www/html/wp-config.php
sudo sed -i '27 a define( 'DB_PASSWORD', '$DBPASSWORD' );' /var/www/html/wp-config.php
sudo sed -i '29 a define( 'DB_HOST', '$hostname.mysql.database.azure.com' );' /var/www/html/wp-config.php


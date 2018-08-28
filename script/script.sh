#!/bin/bash -e
sleep 60
sudo apt-get update -y
sudo apt-get install apache2 php libapache2-mod-php php-mcrypt php-mysql mysql-client -y
sudo cp -r /deployTemp/drop/. /var/www/html/
sudo chown -R www-data.www-data /var/www/html
sudo chmod -R 775 /var/www/html
mysql -u base_user -pubuntuVm2018 -e "create database wordpress; GRANT ALL PRIVILEGES ON worpress.* TO wordpress@testvmss IDENTIFIED BY 'ubuntuVm2018'"
sudo cp /var/www/html/script/wp-config.php /var/www/html/wp-config.php
sudo rm /var/www/html/index.html

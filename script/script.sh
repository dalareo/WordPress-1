#!/bin/bash -e
sleep 180
sudo apt-get update -y
sudo apt-get install apache2 php libapache2-mod-php php-mcrypt php-mysql mysql-client -y
sudo cp -r /deployTemp/drop/. /var/www/html/
sudo chown -R www-data.www-data /var/www/html
sudo chmod -R 775 /var/www/html
mysql -h testvmss.mysql.database.azure.com -u testvmss@testvmss -pubuntuVm2018 -e "CREATE DATABASE wordpress; CREATE USER 'wordpress'@'testvmss' IDENTIFIED BY 'ubuntuVm2018'; GRANT ALL PRIVILEGES ON worpress.* TO 'wordpress'@'testvmss';"
sudo cp /var/www/html/script/wp-config.php /var/www/html/wp-config.php
sudo rm /var/www/html/index.html

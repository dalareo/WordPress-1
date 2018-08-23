#!/bin/bash -e
sudo apt-get update -y
sleep 10
sudo apt-get install apache2 php libapache2-mod-php php-mcrypt php-mysql mysql-client -y
sudo cp -r /deployTemp/drop/. /var/www/html/
sudo chown -R www-data.www-data /var/www/html
sudo chmod -R 775 /var/www/html
sudo cp ./wp-config.php /var/www/html/

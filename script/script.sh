!#/bin/bash
sudo apt-get update -y
sleep 10
sudo apt-get install git apache2 php libapache2-mod-php php-mcrypt php-mysql apt-utils nano curl wget mysql-client -y
sudo cp -r /deployTemp/drop/. /var/www/html/
sudo chown -R www-data.www-data /var/www/html
sudo chmod -R 775 /var/www/html

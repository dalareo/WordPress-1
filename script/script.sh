!#/bin/bash
sudo mkdir -p /var/www/html
sudo rsync -avP /deployTemp/drop/ /var/www/html/

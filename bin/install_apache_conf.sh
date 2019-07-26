#! /bin/bash

curdir=$(dirname "$(readlink -f "$0")")
echo "Copying 000-default.conf to /etc/apache2/sites-available/000-default.conf .."
sudo cp "$curdir/../apache2/000-default.conf" /etc/apache2/sites-available/000-default.conf
sudo a2enmod headers
sudo a2enmod proxy
sudo a2enmod proxy_http
echo "Restarting apache2 server.."
sudo /etc/init.d/apache2 restart # alternatively: systemctl restart apache2


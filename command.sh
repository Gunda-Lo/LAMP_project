#!/bin/bash

set -e

vagrant ssh master <<EOF
    sudo useradd -m -G sudo altschool
    echo -e "Segunda\nSegunda" | sudo passwd altschool
    sudo usermod -aG root altschool
    sudo useradd -ou 0 -g 0 altschool
    sudo -u altschool mkdir -p /home/altschool/.ssh
    sudo -u altschool ssh-keygen -t rsa -b 4096 -f /home/altschool/.ssh/id_rsa -N ""
    sudo cp /home/altschool/.ssh/id_rsa.pub altschoolkey
    sudo ssh-keygen -t rsa -b 4096 -f /home/vagrant/.ssh/id_rsa -N ""
    sudo ssh-keygen -t rsa -b 4096 -f /home/vagrant/.ssh/id_rsa.pub | sshpass -p "vagrant" ssh -o StrictHostKeyChecking=no vagrant@192.168.56.5 'mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys'
    sudo cat ~/altschoolkey | sshpass -p "vagrant"ssh vagrant@192.168.56.5 'mkdir -p ~/.ssh && cat >> ~/.ssh/authoriized_keys'
    sshpass -p "Segunda" sudo -u altschool mkdir -p /mnt/altschool/slave
    sshpass -p "Segunda" sudo -u altschool scp -r /mnt/* vagrant@192.168.56.5:/mnt/altschool/slave
    sudo ps aux > /home/vagrant/running_processes
    exit
EOF

vagrant ssh master <<EOF

echo  "Updating Apt Packages and upgrading latest patches"
sudo apt update -y

sudo apt install apache2 -y

echo  "Adding firewall rule to Apache"
sudo ufw allow in "Apache"

sudo ufw status

echo  "Installing MySQL"
sudo apt install mysql-server -y

echo "Permission for /var/www"
sudo chown -R www-data:www-data /var/www
echo  "Permissions have been set"

sudo apt install php libapache2-mod-php php-mysql -y

echo  "Enabling Module"
sudo a2enmod rewrire
sudo phpenmod mcrypt

sudo sed -i 's/DirectoryIndex index.html index.cgi index.pl index.xhtml index.htm/DirectoryIndex Index.phpindex.html index.cgi index.pl index.xhtml index.htm/' /etc/apache2/mods-enabled/dir.conf

echo  "Restarting Apache"
sudo systemctl reload apache2

echo "Installing Nginx"
sudo apt update
sudo apt install nginx -y

sudo tee /etc/nginx/sites-available/load_balancer <<'NGINX_CONF'
upstream backend {
  server 192.168.56.5; 
  server 192.168.56.6;
}

server {
  listen 80;
  server_name localhost;

  location / {
    proxy_pass http://backend;
  }
}
NGINX_CONF

sudo ln -s /etc/nginx/sites-available/load_balancer /etc/nginx/sites-enabled/

sudo nginx -t

sudo systemctl restart nginx

echo  "Nginx load balancer configuration completed."

echo "LAMP Installation Completed"

exit 0

EOF

vagrant ssh slave <<EOF

echo  "Updating Apt Packages and upgrading latest patches"
sudo apt update -y

sudo apt install apache2 -y

echo  "Adding firewall rule to Apache"
sudo ufw allow in "Apache"

sudo ufw status

echo  "Installing MySQL"
sudo apt install mysql-server -y

echo "Permission for /var/www"
sudo chown -R www-data:www-data /var/www
echo  "Permissions have been set"

sudo apt install php libapache2-mod-php php-mysql -y

echo  "Enabling Module"
sudo a2enmod rewrire
sudo phpenmod mcrypt

sudo sed -i 's/DirectoryIndex index.html index.cgi index.pl index.xhtml index.htm/DirectoryIndex Index.phpindex.html index.cgi index.pl index.xhtml index.htm/' /etc/apache2/mods-enabled/dir.conf

echo  "Restarting Apache"
sudo systemctl reload apache2

echo  "LAMP Installation Completed"

echo "Setting up PHP test page"
echo '<?php' > test.php
echo 'phpinfo();' >> test.php
echo '?>' >> test.php

echo "Segunda" | sudo -S cp test.php /var/www/html/

echo "Segunda" | sudo -S scp test.php vagrant@192.168.56.6:/var/www/html/

echo "PHP test page created and copied to the slave."

exit 0

EOF
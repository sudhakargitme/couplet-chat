#!/bin/bash

#update system
apt-get update -y

#install node js 14.x
curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs

#install and update pm2
npm install -g pm2
pm2 update

# set pm2 to start automatically on system startup
sudo pm2 startup systemd

# install nginx
sudo apt-get install -y nginx

# allow ssh connections through firewall
sudo ufw allow OpenSSH

# allow http & https through firewall
sudo ufw allow 'Nginx Full'

# enable firewall
sudo ufw --force enable

# configure nginx reverse proxy
sudo cat << EOF > /etc/nginx/sites-available/default
server {
  listen 80 default_server;
  server_name _;

  location / {
    proxy_pass http://localhost:3000;
  }
}
EOF

# restart nginx
sudo systemctl restart nginx

#clean up and create root app directory
export app_root=/usr/coupletapp

if [ -d "$app_root" ];then
  rm -rf /usr/coupletapp
  mkdir -p /usr/coupletapp
else
  mkdir -p /usr/coupletapp
fi
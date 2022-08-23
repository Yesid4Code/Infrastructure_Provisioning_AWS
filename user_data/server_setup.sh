#!/usr/bin/bash

sudo apt update -y
sudo apt install apache2 -y
sudo systemctl enable apache2
sudo systemctl start apache2

echo "<h1>Hello World from EC2 $(hostname -f)</h1>" > /var/www/html/index.html

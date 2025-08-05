#!/bin/bash
# Provision Sparta test app

echo "Updating package list..."
sudo apt-get update -y
echo "Package list updated."

echo "Upgrading installed packages..."
sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
echo "Packages upgraded."

echo "Installing Nginx..."
sudo apt-get install nginx -y
echo "Nginx installed."

echo "Configuring Nginx reverse proxy..."
sudo sed -i 's|try_files \$uri \$uri/ =404;|proxy_pass http://localhost:3000;|' /etc/nginx/sites-available/default
echo "Nginx reverse proxy configured."

echo "Testing and reloading Nginx configuration..."
sudo nginx -t
sudo systemctl reload nginx
echo "Nginx reloaded."

echo "Installing Node.js v20..."
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs
echo "Node.js installed."
node -v

echo "Cloning application repository..."
git clone https://github.com/ramyadeena/tech508-sparta-app-1.git repo
echo "Repository cloned."

echo "Changing to app directory..."
cd repo/app

echo "Setting environment variable for database connection..."
export DB_HOST="mongodb://172.31.24.151:27017/posts"

echo "Installing Node.js packages for the app..."
npm install
echo "Packages installed."

echo "Starting application..."
npm start

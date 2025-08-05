
#!/bin/bash
#provision sparta test app

echo "Update ...."
sudo DEBIAN_FRONTEND=noninteractive apt-get update
echo "Done"
echo

# Fix! expects user input

sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

# Fix! expects user input

sudo DEBIAN_FRONTEND=noninteractive apt-get install nginx -y

# configure reverse proxy using nginx

#Installing NodesJs v20
sudo DEBIAN_FRONTEND=noninteractive bash -c "curl -fsSL https://deb.nodesource.com/setup_20.x | bash -" && \
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs

#check node version
node -v

#Install pm2 globally
sudo npm install -g pm2

# git clone command
git clone https://github.com/ramyadeena/tech508-sparta-app-1.git repo

 
# cd into app folder
cd repo/app

# set env var for connections to database
# comment this out
export DB_HOST=mongodb://172.31.24.151:27017/posts

#Install package for the app
#npm install

npm install
 
# Manage app with pm2
pm2 kill
pm2 start npm --name "tech508-sparta-app1" -- start
pm2 save

# Start app
#npm start

echo "Configuring Nginx as reverse proxy..."

# Backup existing default nginx config
sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak.$(date +%F-%H%M%S)

# Replace or add proxy_pass line to point to http://127.0.0.1:3000
sudo sed -i -E '/location \/ {/,/}/ s|proxy_pass http://[^;]+;|proxy_pass http://127.0.0.1:3000;|' /etc/nginx/sites-available/default

# If no proxy_pass line was found and replaced, add it inside location / block
if ! grep -q "proxy_pass http://127.0.0.1:3000;" /etc/nginx/sites-available/default; then
  sudo sed -i '/location \/ {/a \    proxy_pass http://127.0.0.1:3000;' /etc/nginx/sites-available/default
fi

# Test nginx config
sudo nginx -t

# Reload nginx to apply changes
sudo systemctl reload nginx

echo "Nginx reverse proxy configured."

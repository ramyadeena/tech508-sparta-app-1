
#!/bin/bash
#provision sparta test app

echo "Update ...."
sudo apt-get update
echo "Done"
echo

# Fix! expects user input

sudo apt-get upgrade -y

# Fix! expects user input

sudo apt-get install nginx -y

# configure reverse proxy using nginx

#Installing NodesJs v20
sudo DEBIAN_FRONTEND=noninteractive bash -c "curl -fsSL https://deb.nodesource.com/setup_20.x | bash -" && \
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs

#check node version
node -v

# git clone command
git clone https://github.com/ramyadeena/tech508-sparta-app-1.git repo


# set env var for connections to database
# comment this out
export DB_HOST=mongodb://172.31.24.151:27017/posts
 
# cd into app folder
cd repo/app

#Install package for the app
npm install

# Start app
npm start

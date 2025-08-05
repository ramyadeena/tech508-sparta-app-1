#!/bin/bash
set -e  # Exit immediately if a command fails

# Import the MongoDB public key
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
    gpg --dearmor | sudo tee /usr/share/keyrings/mongodb-server-7.0.gpg > /dev/null

# Create the MongoDB list file
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" \
    | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

# Reload the package database
sudo apt-get update -y

# Install MongoDB without prompting
sudo apt-get install -y \
   mongodb-org=7.0.22 \
   mongodb-org-database=7.0.22 \
   mongodb-org-server=7.0.22 \
   mongodb-mongosh \
   mongodb-org-shell=7.0.22 \
   mongodb-org-mongos=7.0.22 \
   mongodb-org-tools=7.0.22 \
   mongodb-org-database-tools-extra=7.0.22

# Backup the default MongoDB configuration
sudo cp /etc/mongod.conf /etc/mongod.conf.bk

# Update bindIp to allow remote connections
sudo sed -i 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/' /etc/mongod.conf

# Start and enable MongoDB
sudo systemctl start mongod
sudo systemctl enable mongod

# Show MongoDB status
sudo systemctl status mongod --no-pager

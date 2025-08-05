
#import  the public key
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
 gpg --dearmor | \ sudo tee /usr/share/keyrings/mongodb-server-7.0.gpg > /dev/null

# create list file
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

#Reload the package database
sudo apt-get update

#install mongodb
sudo apt-get install -y \
   mongodb-org=7.0.22 \
   mongodb-org-database=7.0.22 \
   mongodb-org-server=7.0.22 \
   mongodb-mongosh \
   mongodb-org-shell=7.0.22 \
   mongodb-org-mongos=7.0.22 \
   mongodb-org-tools=7.0.22 \
   mongodb-org-database-tools-extra=7.0.22
   
# sudo systemctl status mongod


# Take a back up file for mongod.configure

sudo cp /etc/mongod.conf /etc/mongod.conf.bk


# use sed command:
sudo sed -i 's/bindIp:127.0.0.1/bindIp: 0.0.0.0/' /etc/mongod.conf

#cd /etc
#sudo nano mongod.conf
#export DB_HOST=mongodb://172.31.24.86:27017/posts

sudo systemctl start mongod
sudo systemctl enable mongod

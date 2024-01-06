#!/bin/bash

# Update package list
apt-get update
apt install software-properties-common

# Install essential tools
apt-get install -y git curl golang npm mysql

# Update and upgrade system
apt update
apt upgrade -y

# Install necessary tools
apt install -y git curl wget software-properties-common

#Add repositories
add-apt-repository ppa:strukturag/libheif
add-apt-repository ppa:strukturag/libde265

# Install dependencies
apt install -y libdlib-dev libblas-dev libatlas-base-dev liblapack-dev libjpeg-turbo8-dev build-essential \
  libdlib19 libdlib-dev libblas-dev libatlas-base-dev liblapack-dev libjpeg-dev libheif-dev pkg-config gpg

# Install Golang
apt install golang-go
wget https://golang.org/dl/go1.16.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.16.linux-amd64.tar.gz
rm go1.16.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> "$HOME/.bashrc" && source "$HOME/.bashrc"
go version

# Install Node.js and NPM
curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
apt install -y nodejs

# Download and build Photoview
mkdir -p /opt/photoview
cd /opt
git clone https://github.com/photoview/photoview.git
cd photoview/

# Build the Web user-interface
cd ui/
npm install
npm run build

# Build the API back-end
cd ../api/
go build -v -o photoview .

# Copy needed files
cd /opt/photoview
mkdir app
cp -r ui/build/ app/ui/
cp api/photoview app/photoview
cp -r api/data/ app/data/

# Configure database
# (Assuming MySQL is used, update the credentials accordingly)
mysql -e "CREATE USER 'photoview'@'localhost' IDENTIFIED BY 'Photo_Secret#12345'; \
  CREATE DATABASE photoview; \
  GRANT ALL PRIVILEGES ON photoview.* TO 'photoview'@'localhost';"

# Configure Photoview
cp api/example.env app/.env
# Edit .env file to match database configuration
# (Replace user, password, and dbname accordingly)
sed -i 's/PHOTOVIEW_DATABASE_DRIVER=mysql/PHOTOVIEW_DATABASE_DRIVER=mysql/' app/.env
sed -i 's|PHOTOVIEW_MYSQL_URL=user:password@tcp(localhost)/dbname|PHOTOVIEW_MYSQL_URL=photoview:Photo_Secret#12345@tcp(localhost)/photoview|' app/.env
echo "PHOTOVIEW_SERVE_UI=1" >> app/.env
echo "PHOTOVIEW_PUBLIC_ENDPOINT=http://localhost:4001/" >> app/.env

# Install optional dependencies
apt install -y darktable ffmpeg exiftool

# Post-installation
echo "Photoview installation complete. Start Photoview using:"
echo "cd /opt/photoview && ./app/photoview"

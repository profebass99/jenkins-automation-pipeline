#!/bin/bash

# update packages
echo "Updating packages"
sudo yum update -y

# install required packages
echo "Installing required packages"
echo "############################"
sudo yum install wget httpd unzip -y

# create a directory
echo "Creating directory"
echo "########################"
sudo mkdir -p ~/webcontents/

# download web content from the web
echo "Downloading web file"
echo "############################"
sudo wget -O ~/webcontents/orthoc.zip https://github.com/technext/orthoc/releases/download/v.1.0.0/orthoc.zip

# extract file contents
echo "Extracting file contents"
sudo unzip ~/webcontents/orthoc.zip -d ~/webcontents/
echo "########################"

# copy file contents
echo "Copying file contents"
echo "#########################"
sudo cp -r ~/webcontents/orthoc/* /var/www/html/.

# restart httpd service
echo "Restarting httpd service"
sudo systemctl start httpd
sudo systemctl enable httpd


# cleanup temporary files
echo "Cleaning up temporary files"
echo "########################"
sudo rm -rf ~/webcontents

echo "We are done!!"

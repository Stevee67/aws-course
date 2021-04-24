#!/bin/bash -xe
yum update -y
yum install httpd -y
yum install -y java-1.8.0-openjdk
service httpd start
chkconfig httpd on
cd /var/www/html
echo "<html><h1>This is WebServer from ${subnet} subnet</h1></html>" > index.html
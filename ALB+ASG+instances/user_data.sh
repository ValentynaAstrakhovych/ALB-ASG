#!/bin/bash

# Install Apache
sudo apt update
sudo apt install -y apache2
sudo apt install stress

# Determine current public and private IP address using AWS CLI
public_ip_address=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
private_ip_address=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

# Create HTML file with IP address
sudo bash -c 'cat  > /var/www/html/index.html' <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>Web Server</title>
</head>
<body>
    <h1>Apache Server</h1>
    <h3>Public IP: ${public_ip_address}</h3>
    <h3>Private IP: ${private_ip_address}</h3>
</body>
</html>
EOF

# Restart Apache to apply changes
sudo systemctl restart apache2

stress --cpu 1 --io 1 --vm 1 --vm-bytes 1024M --timeout 3600s
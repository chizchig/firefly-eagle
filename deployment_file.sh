#!/bin/bash

# Install Nginx
apt-get update
apt-get install -y nginx

# Create the website directory
WEBSITE_DIR="/var/www/mywebsite"
mkdir -p $WEBSITE_DIR

# Create the index.html file
cat <<EOF > $WEBSITE_DIR/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Welcome to My Website</title>
</head>
<body>
    <h1>Hello, welcome to My Website!</h1>
    <p>This is the home page.</p>
    <a href="/about.html">Go to About Page</a>
</body>
</html>
EOF

# Create the about.html file
cat <<EOF > $WEBSITE_DIR/about.html
<!DOCTYPE html>
<html>
<head>
    <title>About Us</title>
</head>
<body>
    <h1>About Us</h1>
    <p>This is the About Us page.</p>
    <a href="/">Back to Home</a>
</body>
</html>
EOF

# Configure Nginx virtual host
cat <<EOF > /etc/nginx/sites-available/mywebsite
server {
    listen 80;
    server_name mywebsite.com;

    root $WEBSITE_DIR;
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

# Enable the virtual host
ln -s /etc/nginx/sites-available/mywebsite /etc/nginx/sites-enabled/

# Remove default Nginx config (if present)
rm /etc/nginx/sites-enabled/default

# Restart Nginx
systemctl restart nginx

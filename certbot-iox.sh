#!/bin/sh
echo "Start iox script - Creating directories" 
cp -r  $CAF_APP_CONFIG_FILE /etc/letsencrypt/cli.ini
mkdir -p /etc/letsencrypt/logs
mkdir -p /etc/letsencrypt/work

# Remove certbot-iox.log
rm -f /etc/letsencrypt/certbot-iox.log

echo "Running Certbot" 2>&1 > /etc/letsencrypt/certbot-iox.log
certbot certonly --force-renewal 2>&1 >> /etc/letsencrypt/certbot-iox.log

echo "Certbot run complete" 2>&1 >> /etc/letsencrypt/certbot-iox.log


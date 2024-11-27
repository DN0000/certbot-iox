#!/bin/sh
echo "Start iox script - Creating directories" 
cp -r  $CAF_APP_CONFIG_FILE /etc/letsencrypt/cli.ini
mkdir -p /etc/letsencrypt/logs
mkdir -p /etc/letsencrypt/work

# Remove certbot-iox.log
rm -f /etc/letsencrypt/certbot-iox.log

echo "First run of Certbot" 2>&1 > /etc/letsencrypt/certbot-iox.log
certbot certonly 2>&1 >> /etc/letsencrypt/certbot-iox.log
echo "Certbot first run complete" 2>&1 >> /etc/letsencrypt/certbot-iox.log


# crond in foreground
crond -f -l 2 2>&1 >> /etc/letsencrypt/certbot-iox.log
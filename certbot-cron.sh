#!/bin/sh
# Certbot renewal script 

mv /etc/letsencrypt/certbot-iox.log /etc/letsencrypt/certbot-iox.old

echo "certbot cron job running" 2>&1 > /etc/letsencrypt/certbot-iox.log | tee /dev/ttyS2
certbot renew 2>&1 >> /etc/letsencrypt/certbot-iox.log
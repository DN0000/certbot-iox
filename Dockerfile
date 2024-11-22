FROM certbot/certbot:latest

# Install dcron and bash using Alpine's package manager
RUN apk update && apk add --no-cache bash dcron

# Install the DNS Made Easy plugin
RUN pip install certbot-dns-dnsmadeeasy

# Copy the renewal script
COPY renew.sh /usr/local/bin/renew.sh
RUN chmod +x /usr/local/bin/renew.sh

# Copy the post-deployment script
COPY post-deploy.sh /usr/local/bin/post-deploy.sh
RUN chmod +x /usr/local/bin/post-deploy.sh

# Copy the cron job configuration
COPY certbot-cron /etc/crontabs/root
RUN chmod 0644 /etc/crontabs/root

# Start cron in the foreground to keep the container running
CMD ["crond", "-f"]

FROM certbot/certbot:latest

# Install dcron
RUN apk add --no-cache dcron

# Copy the post-deployment script
COPY post-deploy.sh /usr/local/bin/post-deploy.sh
RUN chmod +x /usr/local/bin/post-deploy.sh

# Copy the deployment script
COPY certbot-iox.sh /usr/local/bin/certbot-iox.sh
RUN chmod +x /usr/local/bin/certbot-iox.sh

# Copy the script into the daily cron directory
COPY certbot-cron.sh /etc/periodic/daily/certbot-cron
RUN chmod +x /etc/periodic/daily/certbot-cron


# Set the entry point to execute the full command with shell
ENTRYPOINT 'certbot-iox.sh'


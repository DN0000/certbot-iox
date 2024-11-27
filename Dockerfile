FROM certbot/certbot:latest

# Copy the post-deployment script
COPY post-deploy.sh /usr/local/bin/post-deploy.sh
RUN chmod +x /usr/local/bin/post-deploy.sh

# Copy the deployment script
COPY certbot-iox.sh /usr/local/bin/certbot-iox.sh
RUN chmod +x /usr/local/bin/certbot-iox.sh



# Set the entry point to execute the full command with shell
ENTRYPOINT 'certbot-iox.sh'


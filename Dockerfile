FROM certbot/certbot:latest

RUN mkdir -p /root/

# Copy the post-deployment script
COPY post-deploy.sh /usr/local/bin/post-deploy.sh
RUN chmod +x /usr/local/bin/post-deploy.sh

# Copy the deployment script
COPY certbot-iox.sh /usr/local/bin/certbot-iox.sh
RUN chmod +x /usr/local/bin/certbot-iox.sh


# Kick it off
CMD ["/usr/local/bin/certbot-iox.sh"]

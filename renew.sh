#!/bin/bash

# Ensure DNS credentials are set
if [[ -z "$DNSMADEEASY_API_KEY" || -z "$DNSMADEEASY_SECRET_KEY" ]]; then
  echo "Error: DNS Made Easy credentials are not set."
  exit 1
fi

# Set staging flag
STAGING_FLAG=""
if [[ "$STAGING" == "1" ]]; then
  STAGING_FLAG="--staging"
  echo "Running in STAGING mode."
else
  echo "Running in PRODUCTION mode."
fi

# Run the Certbot renewal command
certbot renew \
  $STAGING_FLAG \
  --dns-dnsmadeeasy \
  --dns-dnsmadeeasy-propagation-seconds 60 \
  --dns-dnsmadeeasy-api-key "$DNSMADEEASY_API_KEY" \
  --dns-dnsmadeeasy-api-secret "$DNSMADEEASY_SECRET_KEY" \
  --deploy-hook "/usr/local/bin/post-deploy.sh"


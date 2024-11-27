#!/bin/sh
set -e

# Function to log messages

echo "Start Deploy Script" 2>&1 | tee /dev/ttyS2 | tee /dev/ttyS3

TEMP_DIR=$(mktemp -d -t certbot-XXXXXX)
COMBINED_PEM="$TEMP_DIR/combined.pem"
PKCS12_FILE="/etc/letsencrypt/certbot-iox.p12"
CERT_NAME="LE Cert"

# Navigate to the directory containing the renewed certificates
cd "$RENEWED_LINEAGE" || {
    echo "Error: Failed to change directory to $RENEWED_LINEAGE." 2>&1 | tee /dev/ttyS2 | tee /dev/ttyS3
    exit 1
}
echo "Changed directory to $RENEWED_LINEAGE." 2>&1 | tee /dev/ttyS2 | tee /dev/ttyS3

# Check for the existence of required certificate files
if [ -f privkey.pem ] && [ -f fullchain.pem ]; then
    echo "Found privkey.pem and fullchain.pem." 

    # Combine private key and full chain into a single PEM file
    cat privkey.pem fullchain.pem > "$COMBINED_PEM"
    echo "Combined privkey.pem and fullchain.pem into $COMBINED_PEM." 2>&1 | tee /dev/ttyS2 | tee /dev/ttyS3

    # Export the combined PEM to a PKCS#12 file
    if openssl pkcs12 -export -in "$COMBINED_PEM" -name "$CERT_NAME" -passout pass:cisco -out "$PKCS12_FILE"; then
        # Sleep to avoid rate limiting
        sleep 5
        echo "Exported $COMBINED_PEM to $PKCS12_FILE. READY TO DEPLOY CERTIFICATE" 2>&1 | tee /dev/ttyS2 >> /etc/letsencrypt/certbot-iox.log
    else
        echo "Error: Failed to export $COMBINED_PEM to $PKCS12_FILE." 2>&1 | tee /dev/ttyS2 | tee /dev/ttyS3
        exit 1
    fi
else
    echo "Error: privkey.pem or fullchain.pem not found in $RENEWED_LINEAGE." 2>&1 | tee /dev/ttyS2 | tee /dev/ttyS3
    exit 1
fi
 
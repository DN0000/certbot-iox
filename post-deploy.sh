#!/bin/sh
set -e

# Redirect all output to syslog
exec > /dev/ttyS2 2>&1

# Function to log messages
log_message() {
    echo "CERTBOT - post-deploy.sh - $1"
}

# Trap errors and cleanup
cleanup() {
    rm -f "$COMBINED_PEM"
    log_message "Cleaned up temporary files."
}
trap cleanup EXIT

# Constants
TEMP_DIR=$(mktemp -d)
COMBINED_PEM="$TEMP_DIR/combined.pem"
PKCS12_FILE="/root/certbot/ciscoautocert.p12"


# Navigate to the directory containing the renewed certificates
cd "$RENEWED_LINEAGE"
log_message "Started Deploy Script"
log_message "Changed directory to $RENEWED_LINEAGE."

# Check for the existence of required certificate files
if [ -f privkey.pem ] && [ -f fullchain.pem ]; then
    log_message "Found privkey.pem and fullchain.pem."

    # Combine private key and full chain into a single PEM file
    cat privkey.pem fullchain.pem > "$COMBINED_PEM"
    log_message "Combined privkey.pem and fullchain.pem into $COMBINED_PEM."

    # Export the combined PEM to a PKCS#12 file
    openssl pkcs12 -export -in "$COMBINED_PEM" -name "$CERT_NAME" -passout pass:cisco -out "$PKCS12_FILE"
    log_message "Exported $COMBINED_PEM to $PKCS12_FILE."

else
    log_message "Error: privkey.pem or fullchain.pem not found in $RENEWED_LINEAGE."
    exit 1
fi

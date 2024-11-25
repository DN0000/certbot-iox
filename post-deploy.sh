#!/bin/sh
set -e

# Function to log messages
log_message() {
    echo "post-deploy.sh - $1" | tee /dev/ttyS2
}

# Trap errors and cleanup
cleanup() {
    if [ -n "$COMBINED_PEM" ] && [ -f "$COMBINED_PEM" ]; then
        rm -f "$COMBINED_PEM"
        log_message "Cleaned up temporary file: $COMBINED_PEM."
    fi
    if [ -n "$TEMP_DIR" ] && [ -d "$TEMP_DIR" ]; then
        rmdir "$TEMP_DIR"
        log_message "Removed temporary directory: $TEMP_DIR."
    fi
}
trap cleanup EXIT

# Create a secure temporary directory
TEMP_DIR=$(mktemp -d -t certbot-XXXXXX)
COMBINED_PEM="$TEMP_DIR/combined.pem"
PKCS12_FILE="/root/certbot/ciscoautocert.p12"

# Navigate to the directory containing the renewed certificates
cd "$RENEWED_LINEAGE" || {
    log_message "Error: Failed to change directory to $RENEWED_LINEAGE."
    exit 1
}
log_message "Changed directory to $RENEWED_LINEAGE."

# Check for the existence of required certificate files
if [ -f privkey.pem ] && [ -f fullchain.pem ]; then
    log_message "Found privkey.pem and fullchain.pem."

    # Combine private key and full chain into a single PEM file
    cat privkey.pem fullchain.pem > "$COMBINED_PEM"
    chmod 600 "$COMBINED_PEM"
    log_message "Combined privkey.pem and fullchain.pem into $COMBINED_PEM with restricted permissions."

    # Ensure the directory for PKCS12_FILE exists
    PKCS12_DIR=$(dirname "$PKCS12_FILE")
    if [ ! -d "$PKCS12_DIR" ]; then
        mkdir -p "$PKCS12_DIR"
        log_message "Created directory $PKCS12_DIR."
    fi

    # Export the combined PEM to a PKCS#12 file
    if openssl pkcs12 -export -in "$COMBINED_PEM" -name "$CERT_NAME" -passout pass:cisco -out "$PKCS12_FILE"; then
        log_message "Exported $COMBINED_PEM to $PKCS12_FILE."
    else
        log_message "Error: Failed to export $COMBINED_PEM to $PKCS12_FILE."
        exit 1
    fi
else
    log_message "Error: privkey.pem or fullchain.pem not found in $RENEWED_LINEAGE."
    exit 1
fi

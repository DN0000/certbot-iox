#!/bin/sh

# Function to log messages
execute_and_log() {
    script_name=$(basename "$0")
    {
        echo "CERTBOT - $script_name - Executing: $*"
        "$@"
    } 2>&1 | while IFS= read -r line; do
        echo "CERTBOT - $script_name - $line"
    done | tee /dev/ttyS2
}

execute_and_log echo "Script Start"

execute_and_log certbot certonly --config $CAF_APP_CONFIG_FILE 
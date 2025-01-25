#!/bin/bash
set -e

# Function to log messages
log() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1"
}

# Create key-file for Snowflake
log "Creating key file for Snowflake..."
if echo "${SNOWFLAKE_RSA_KEY}" | tr -d '\r' > /tmp/rsa_key.p8; then
    log "Key file created successfully."
else
    log "Failed to create key file."
    exit 1
fi

# Replace env variables in context.xml
if envsubst < /usr/local/tomcat/conf/context.xml.template > /usr/local/tomcat/conf/context.xml; then
    log "Environment variables replaced successfully."
else
    log "Failed to replace environment variables."
    exit 1
fi

# Ensure Key-pair decryption works
# https://docs.snowflake.com/en/developer-guide/jdbc/jdbc-configure#key-decryption-errors
export CATALINA_OPTS="$CATALINA_OPTS -Dnet.snowflake.jdbc.enableBouncyCastle=true"

# Start Tomcat
log "Starting Tomcat..."
catalina.sh run &
CATALINA_PID=$!

# Wait for a few seconds to ensure Tomcat has started
sleep 5

# Check if the process is still running
if ps -p $CATALINA_PID > /dev/null; then
    log "Tomcat started successfully."
else
    log "Failed to start Tomcat."
    exit 1
fi

# Follow Tomcat logs
log "Following Tomcat logs..."
touch /usr/local/tomcat/logs/catalina.out
tail -f /usr/local/tomcat/logs/catalina.out

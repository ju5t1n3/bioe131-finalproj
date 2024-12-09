#!/bin/bash

# Function for logging
log() {
    echo "[INFO] $1"
}

# Ensure the script is not run as root
if [ "$(id -u)" -eq 0 ]; then
    echo "[ERROR] Do not run this script as root. Exiting."
    exit 1
fi

# Step 1: Start Apache2 Server
log "Starting Apache2 server."
sudo service apache2 start

# Verify Apache2 is running
if sudo service apache2 status | grep -q "active (running)"; then
    log "Apache2 server is running."
else
    echo "[ERROR] Apache2 server failed to start. Exiting."
    exit 1
fi

# Step 2: Determine the Apache root directory
log "Determining the Apache root directory."

# Check for common Apache root directories
COMMON_APACHE_DIRS=("/var/www/html" "/opt/homebrew/var/www" "/usr/local/var/www")
APACHE_ROOT=""

for dir in "${COMMON_APACHE_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        APACHE_ROOT="$dir"
        break
    fi
done

if [ -z "$APACHE_ROOT" ]; then
    log "Apache root directory not found in common locations. Searching system."
    APACHE_ROOT=$(sudo find / -name "www" 2>/dev/null | grep -m 1 "www/html" || echo "")
fi

if [ -z "$APACHE_ROOT" ]; then
    echo "[ERROR] Apache root directory not found. Exiting."
    exit 1
else
    log "Apache root directory found: $APACHE_ROOT"
fi

# Export the Apache root directory for future commands
export APACHE_ROOT="$APACHE_ROOT"

# Step 3: Verify access to the Apache2 server
log "Attempting to access the Apache2 server at localhost."
echo "Visit http://localhost/ in your browser to verify the server is running and shows 'It works!'."

# Step 4: Download and install JBrowse 2
log "Setting up JBrowse 2."

# Create a temporary working directory
log "Creating temporary directory at ~/tmp."
mkdir -p ~/tmp && cd ~/tmp

# Create a JBrowse2 folder and move it to the Apache root
jbrowse create jbrowse_output
log "Copying JBrowse2 files to the Apache root directory."
sudo mv jbrowse_output "$APACHE_ROOT/jbrowse2"

# Change ownership of the JBrowse2 directory
log "Changing ownership of JBrowse2 files to the current user."
sudo chown -R $(whoami) "$APACHE_ROOT/jbrowse2"

# Verify JBrowse 2 setup
log "JBrowse 2 setup complete. Verify by accessing: http://localhost/jbrowse2"

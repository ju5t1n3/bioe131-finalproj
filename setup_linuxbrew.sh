#!/bin/bash

# Function for logging
log() {
    echo "[INFO] $1"
}

# Ensure the script is not being run as root
if [ "$(id -u)" -eq 0 ]; then
    echo "[ERROR] Do not run this script as root. Exiting."
    exit 1
fi

log "Starting setup for Linuxbrew on Debian/Ubuntu."

# Step 1: Switch to root temporarily and set a password
log "Switching to root to set a password for the 'ubuntu' user."
sudo su -c "
    echo '[INFO] Setting password for ubuntu user.'
    passwd ubuntu
"

if [ $? -ne 0 ]; then
    echo "[ERROR] Failed to set the 'ubuntu' user password. Exiting."
    exit 1
fi

log "Password for 'ubuntu' user set successfully. Exiting root session."

# Step 2: Install Homebrew
log "Installing Homebrew. You will be prompted for your password."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

if [ $? -ne 0 ]; then
    echo "[ERROR] Homebrew installation failed. Exiting."
    exit 1
fi

log "Homebrew installed successfully."

# Step 3: Add Homebrew to PATH
log "Adding Homebrew to the execution path."
BREW_ENV='eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"'
echo >> ~/.bashrc
echo "$BREW_ENV" >> ~/.bashrc
eval "$BREW_ENV"

if [ $? -ne 0 ]; then
    echo "[ERROR] Failed to update PATH for Homebrew. Exiting."
    exit 1
fi

log "Homebrew added to PATH successfully. Remember to run 'source ~/.bashrc' if the PATH is not updated immediately."

# Confirm the installation
log "Verifying Homebrew installation."
brew --version

if [ $? -ne 0 ]; then
    echo "[ERROR] Homebrew verification failed. Exiting."
    exit 1
fi

log "Homebrew setup completed successfully."
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

# Check if Node.js is already installed
log "Checking for existing Node.js installation."
if command -v node &>/dev/null; then
    NODE_VERSION=$(node -v)
    log "Node.js is already installed: $NODE_VERSION"
    if [[ $NODE_VERSION == v20* ]]; then
        log "Node.js v20 is already installed. Skipping installation."
    else
        log "A different version of Node.js is installed. Proceeding with Node.js v20 installation."
    fi
else
    log "Node.js is not installed. Proceeding with installation."
fi

# Ensure unzip is installed
log "Checking for unzip utility."
if ! dpkg -l | grep -qw unzip; then
    log "Installing unzip."
    sudo apt update && sudo apt install -y unzip
else
    log "Unzip is already installed."
fi

# Install fnm (Fast Node Manager)
log "Installing Fast Node Manager (fnm)."
curl -fsSL https://fnm.vercel.app/install | bash

# Source ~/.bashrc to load fnm into the current shell environment
log "Applying fnm configuration to the current session."
source ~/.bashrc

# Activate fnm
log "Activating fnm."
source ~/.bashrc

# Install and use Node.js v20
log "Installing and setting up Node.js v20 using fnm."
fnm use --install-if-missing 20

# Verify Node.js and npm installations
log "Verifying Node.js and npm versions."
NODE_VERSION=$(node -v)
NPM_VERSION=$(npm -v)

if [[ $NODE_VERSION == v20* ]]; then
    log "Node.js installation successful: $NODE_VERSION"
else
    echo "[ERROR] Node.js installation failed. Exiting."
    exit 1
fi

if [[ $NPM_VERSION ]]; then
    log "npm installation successful: $NPM_VERSION"
else
    echo "[ERROR] npm installation failed. Exiting."
    exit 1
fi

# Install JBrowse CLI
log "Installing JBrowse CLI."
npm install -g @jbrowse/cli

# Verify JBrowse CLI installation
log "Verifying JBrowse CLI installation."
if command -v jbrowse &>/dev/null; then
    JBROWSE_VERSION=$(jbrowse --version)
    log "JBrowse CLI installed successfully: $JBROWSE_VERSION"
else
    echo "[ERROR] JBrowse CLI installation failed. Exiting."
    exit 1
fi

# Install additional dependencies
log "Installing wget and Apache2."
sudo apt install -y wget apache2

log "Installing samtools and htslib via Homebrew."
brew install samtools htslib

# Verify installations
log "Verifying wget installation."
if command -v wget &>/dev/null; then
    log "wget installed successfully."
else
    echo "[ERROR] wget installation failed. Exiting."
    exit 1
fi

log "Verifying Apache2 installation."
if command -v apache2 &>/dev/null; then
    log "Apache2 installed successfully."
else
    echo "[ERROR] Apache2 installation failed. Exiting."
    exit 1
fi

log "Verifying samtools installation."
if command -v samtools &>/dev/null; then
    log "samtools installed successfully."
else
    echo "[ERROR] samtools installation failed. Exiting."
    exit 1
fi

log "Verifying htslib installation."
if command -v bgzip &>/dev/null; then
    log "htslib installed successfully."
else
    echo "[ERROR] htslib installation failed. Exiting."
    exit 1
fi

log "Setup completed successfully. JBrowse, Node.js, and required dependencies are ready."
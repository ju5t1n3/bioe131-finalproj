#!/bin/bash

set -e # Exit on errors
set -u # Treat unset variables as errors

# Function to log actions
log() {
    echo "[INFO] $1"
}

# Install Homebrew
install_homebrew() {
    if ! command -v brew >/dev/null 2>&1; then
        log "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        log "Homebrew already installed."
    fi
}

# Install Node.js
install_node() {
    if ! command -v node >/dev/null 2>&1; then
        log "Node.js not found. Installing Node.js version 20..."
        brew install node@20
        log "Adding Node.js to PATH..."
        echo 'export PATH="/opt/homebrew/opt/node@20/bin:$PATH"' >> ~/.zshrc
        source ~/.zshrc
    else
        log "Node.js is already installed. Version: $(node -v)"
    fi
    log "Verifying Node.js and npm versions..."
    node -v
    npm -v
}

# Install JBrowse CLI
install_jbrowse() {
    log "Installing JBrowse CLI..."
    if ! sudo npm install -g @jbrowse/cli; then
        log "Retrying JBrowse installation without sudo..."
        npm install -g @jbrowse/cli
    fi
    log "JBrowse CLI version: $(jbrowse --version)"
}

# Install other tools
install_tools() {
    log "Installing wget, httpd, samtools, and htslib..."
    brew install wget httpd samtools htslib
    log "Starting Apache HTTP Server..."
    sudo brew services start httpd
}

# Setup Conda environment and install NCBI datasets CLI
setup_conda() {
    if ! command -v conda >/dev/null 2>&1; then
        log "Conda is not installed. Please install Conda and try again."
        exit 1
    fi

    log "Creating and activating Conda environment 'ncbi_datasets'..."
    conda create -n ncbi_datasets -y
    conda activate ncbi_datasets
    log "Installing NCBI datasets CLI..."
    conda install -c conda-forge ncbi-datasets-cli -y
}

# Download and prepare genome data
prepare_genome_data() {
    log "Downloading Zaire Ebola genome dataset..."
    datasets download genome taxon 186538 --include genome,gff3 --filename zaire_ebola_dataset.zip
    unzip zaire_ebola_dataset.zip -d zaire_ebola_data

    log "Copying genome data..."
    cp zaire_ebola_data/ncbi_dataset/data/GCF_000848505.1/* .
    rm -rf zaire_ebola_data zaire_ebola_dataset.zip

    log "Renaming genome file..."
    mv GCF_000848505.1_ViralProj14703_genomic.fna genes.fna

    log "Indexing genome with Samtools..."
    samtools faidx genes.fna
}

# Configure JBrowse
configure_jbrowse() {
    log "Adding assembly to JBrowse..."
    jbrowse add-assembly genes.fna --out jbrowse2 --load copy

    log "Sorting and compressing GFF file..."
    jbrowse sort-gff Homo_sapiens.GRCh38.110.chr.gff3 > annotations.gff
    bgzip annotations.gff
    tabix annotations.gff.gz

    log "Adding track to JBrowse..."
    jbrowse add-track annotations.gff.gz --out jbrowse2 --load copy
    jbrowse text-index --out jbrowse2

    log "Configuration complete. Open http://yourhost/jbrowse2/ in your browser."
}

# Main function
main() {
    log "Starting installation script..."
    install_homebrew
    install_node
    install_jbrowse
    install_tools
    setup_conda
    prepare_genome_data
    configure_jbrowse
    log "Installation and setup complete."
}

# Execute main function
main

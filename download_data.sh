#!/bin/bash

# Log function for output
log() {
    echo "[INFO] $1"
}

# Setup NCBI datasets CLI using curl
setup_datasets_cli() {
    log "Downloading NCBI datasets CLI..."
    curl -k -L -o datasets 'https://ftp.ncbi.nlm.nih.gov/pub/datasets/command-line/v2/linux-amd64/datasets'

    # Make the downloaded file executable
    chmod +x datasets

    log "NCBI datasets CLI downloaded and made executable."
}

# Prepare genome data
prepare_genome_data() {
    log "Downloading Zaire Ebola genome dataset..."
    
    # Ensure the datasets command is available in the environment
    datasets download genome taxon 186538 --include genome,gff3 --filename zaire_ebola_dataset.zip
    
    # Check if the download was successful
    if [ ! -f zaire_ebola_dataset.zip ]; then
        echo "[ERROR] Dataset download failed. Exiting."
        exit 1
    fi

    # Unzip the downloaded dataset
    unzip zaire_ebola_dataset.zip -d zaire_ebola_data

    log "Copying genome data..."
    cp zaire_ebola_data/ncbi_dataset/data/GCF_000848505.1/* .

    # Clean up the downloaded files
    rm -rf zaire_ebola_data zaire_ebola_dataset.zip

    log "Renaming genome file..."
    mv GCF_000848505.1_ViralProj14703_genomic.fna genes.fna

    log "Indexing genome with Samtools..."
    samtools faidx genes.fna
}

# Main function
main() {
    log "Starting installation script..."
    setup_datasets_cli
    prepare_genome_data
    log "Download complete."
}

# Execute main function
main

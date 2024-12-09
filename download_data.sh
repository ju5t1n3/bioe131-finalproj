# Setup Conda environment and install NCBI datasets CLI
setup_conda() {
    log "Creating and activating Conda environment 'ncbi_datasets'..."
    conda create -n ncbi_datasets
    conda activate ncbi_datasets
    log "Installing NCBI datasets CLI..."
    conda install -c conda-forge ncbi-datasets-cli
}
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

# Main function
main() {
    log "Starting installation script..."
    setup_conda
    prepare_genome_data
    log "Download complete."
}

# Execute main function
main
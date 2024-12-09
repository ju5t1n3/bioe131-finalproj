# bioe131-finalproj

## How to Install JBrowse2 Instance
### Step 1: Linuxbrew Setup
Make sure you are using a Debian or Ubuntu distribution. Then go ahead and install linuxbrew, using the commands below to run our setup_linuxbrew.sh script:
```
chmod +x setup_linuxbrew.sh
./setup_linuxbrew.sh
```

### Step 2: Install Necessary Tools
Run the commands below (tools_setup.sh script) to install the tools needed which includes Node.js, the JBrowse2 cli, wget, apache2, samtools, and tabix:
```
chmod +x tools_.sh
./tools_setup.sh
```

### Step 3: Setup Apache Server
Run the commands below (setup_apache_jbrowse.sh script) to setup the Apache2 server, getting the host, and downloading JBrowse2:
```
chmod +x setup_apache_jbrowse.sh
./setup_apache_jbrowse.sh
```
In your browser, now type in http://yourhost/jbrowse2/, where yourhost is the localhost. Now you should see the words "It worked!" with a green box underneath saying "JBrowse 2 is installed." with some additional details.

### Step 4: Download and Process Data
Run these commands (download_data.sh script) to download the Filovirus: Zaire Ebola (Mayinga 76) strain genome and annotations:
```
chmod +x download_data.sh
./download_data.sh
```

Then add the tracks to JBrowse2:
```
jbrowse add-assembly genes.fna --out jbrowse2 --load copy
jbrowse sort-gff genomic.gff > annotations.gff
bgzip annotations.gff
tabix annotations.gff.gz
jbrowse add-track annotations.gff.gz --out jbrowse2 --load copy
jbrowse text-index --out jbrowse2
```

### Step 5: Use your genome browser to explore Filovirus proteins amd their structures
Launch JBrowse2 by opening http://yourhost/jbrowse2/ again in your web browser.

### IF... this doesn't work for you, you can refer back to this github lab for the setup instructions
https://github.com/bioe131/lab-8-toussm?tab=readme-ov-file

## Protein Data! The most exciting part ;)
For protein reproducibility, refer to the README.md within jbrowse2/filovirus_proteins. 
Within this folder, you can also find the PDBs if you want to use those directly for the JBrowse protein structure plugin. 

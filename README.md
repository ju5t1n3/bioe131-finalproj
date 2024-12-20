# bioe131-finalproj
### Information about our project: https://docs.google.com/document/d/1uAnVLal8CnHdG5Gwyl7I_Li_2vNgQ_itnFkHl_IxIz4/edit?tab=t.0

## How To Set Up Our Genome Browser
### Step 1: Linuxbrew Setup
Make sure you are using a Debian or Ubuntu distribution. Then go ahead and install linuxbrew, using the commands below to run our setup_linuxbrew.sh script:
```
chmod +x setup_linuxbrew.sh
./setup_linuxbrew.sh
```

### Step 2: Install Necessary Tools
Run the commands below (tools_setup.sh script) to install the tools needed which includes Node.js, the JBrowse2 cli, wget, apache2, samtools, and tabix:
```
chmod +x tools_setup.sh
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

Find and set apache2 server folder:
```
# be sure to replace the path with your actual true path!
export APACHE_ROOT='/path/to/rootdir'
```
If you are really struggling to find the APACHE_ROOT folder, you could try searching for it.
```
sudo find / -name "www" 2>/dev/null
```

Then add the tracks to JBrowse2:
```
jbrowse add-assembly genes.fna --out $APACHE_ROOT/jbrowse2 --load copy
jbrowse sort-gff genomic.gff > annotations.gff
bgzip annotations.gff
tabix annotations.gff.gz
jbrowse add-track annotations.gff.gz --out $APACHE_ROOT/jbrowse2 --load copy
jbrowse text-index --out $APACHE_ROOT/jbrowse2
```

Move the following files into your root jbrowse2 folder, in order to visualize the protein structures!
```
cp -r jbrowse2/filovirus_proteins $APACHE_ROOT/jbrowse2
cp jbrowse2/index.html $APACHE_ROOT/jbrowse2
```

### Step 5: Use your genome browser to explore Filovirus proteins amd their structures
Launch JBrowse2 by opening http://yourhost/jbrowse2/ again in your web browser.

### IF... this doesn't work for you, you can refer back to this github lab for the setup instructions! 
https://github.com/bioe131/lab-8-toussm?tab=readme-ov-file

## Protein Data! The most exciting part ;)
For protein reproducibility, refer to the README.md within jbrowse2/filovirus_proteins. This is optional if you want to reproduce this structure data on your own. However, this will require uploading the jupyter notebook into Google Colab for GPU access. Within this folder, you can also find the PDBs if you want to use those directly for the JBrowse protein structure plugin. 

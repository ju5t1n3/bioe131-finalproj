# ESM for potential therapeutic approaches: Filovirus
We leveraged the ESM3 masked large language model (LLM) to design novel proteins by using selected binding or receptor motifs from these proteins as scaffolds. This work demonstrates the adaptability of generative  models in creating hypothetical protein structures that could inform therapeutic strategies. While these generated proteins are not validated binders, they serve as a proof of concept for the innovative use of AI-driven approaches in therapeutic design. Ultimately, this platform seeks to inspire and educate researchers and students about the intersections of computational biology, protein engineering, and therapeutic innovation. The notebook will show and save both the original filovirus and the generated one with the conserved domain / motif as a scaffold as a target. 

## How to reproduce this data
### Step 1: Download the filovirus_generate_proteins.ipynb

### Step 2: Upload this notebook into a google colab since you need access to a gpu

### Step 3: Run all the cells
There are detailed comments explaining protein generation. The first few cells are simply to show you how all this generation works, with step by step outputs. 

However, if you want to skip straight to reproducing the pdb data in the folders for each filovirus protein, run import, esm model upload, and the generate_and_save function (essentially 
the first 2 and last 2 cells). I used a seed of 42, and if you wish to reproduce my structures exactly, but feel free to use different seeds!

The highlighted residues and crmsd jsons are meant to save this metadata in order to visualize the highlighted domain in a 3D visualizer (e.g. in html). 

Now you have your PDBs -- what's next? 

### Step 4: View PDBs with respective encoding genes in Jbrowse2 instructions: 

1. Go to Tools and Select Plugin Store
2. Install Protein3d
3. Right Click on the Genome track and select Launch protein view
4. Go to Open File Manually
5. Upload the protein you would like to view and click Launch 3-D Protein Structure View
6. Click the wrench icon
7. In the Download Structure box, click Apply
8. There should be a tab called Assembly 1 (or the lowest level tab). Click on it
9. Select Apply Action
10. Select Apply 3D Representation
11. Click Apply
Now you can view your protein

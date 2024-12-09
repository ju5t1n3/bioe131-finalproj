import requests
import os

def download_pdb_by_id(pdb_id, output_dir="pdb_structures"):
    """
    Download the PDB file for a given PDB ID.
    """
    os.makedirs(output_dir, exist_ok=True)
    file_path = os.path.join(output_dir, f"{pdb_id}.pdb")
    
    url = f"https://files.rcsb.org/download/{pdb_id}.pdb"
    response = requests.get(url)
    if response.status_code == 200:
        with open(file_path, "w") as file:
            file.write(response.text)
        print(f"Downloaded PDB file: {pdb_id}")
    else:
        print(f"Failed to download PDB file for {pdb_id}: {response.status_code}")

pdbs = ['5DVW', '3FKE', '2EBO', '4M0Q', '7K5L', '4QB0']

for i in pdbs:
    download_pdb_by_id(i)


    


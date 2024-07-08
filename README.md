# ARC-OMERO

A plugin for [omero-cli-transfer](https://github.com/ome/omero-cli-transfer) to export imaging projects from ARC repositories to the OMERO image data management system.

## Usage

```
omero transfer prepare --plugin arc_omero ARC_DATASET_FOLDER
omero transfer unpack --folder ARC_DATASET_FOLDER # Not dependent on the plugin  
```

## Development Environment Setup

To setup the environment:
```
# 1) Setup a python3 environment with conda
conda create -n myenv -c conda-forge python=3.8 zeroc-ice=3.6.5
conda activate myvenv

# 2) Clone the forked omero-cli-transfer repo
git clone https://github.com/MicheleBortol/omero-cli-transfer.git

# 3) Install bftools (necessary for omero-cli-transfer prepare)
wget https://downloads.openmicroscopy.org/bio-formats/7.1.0/artifacts/bftools.zip
unzip bftools.zip
mkdir bin
mv bftools bin/
export PATH=$(pwd)/arc_omero_dev/bin/bftools:$PATH 

# 4) Install omero-cli-transfer with the plugins enabled for the prepare function
cd omero-cli-transfer
git checkout omero_arc_importer
pip install .

# 5)Clone and install this repo 
cd ..
git clone https://github.com/MicheleBortol/arc_omero.git
cd arc_omero
pip install .
cd ..
```


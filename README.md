# ARC-OMERO

A plugin for [omero-cli-transfer](https://github.com/ome/omero-cli-transfer) to export imaging projects from ARC repositories to the OMERO image data management system.

## Usage

```
omero transfer prepare --plugin arc_omero ARC_DATASET_FOLDER
```

## Development Environment Setup

To setup the environment:
```
# 1) Setup a python3 virtual environment
python3 -m venv arc_omero_dev
source arc_omero_dev/bin/activate

# 2) Clone the forked omero-cli-transfer repo
git clone https://github.com/MicheleBortol/omero-cli-transfer.git

# 3) Install omero-cli-transfer with the plugins enabled for the prepare function
cd omero-cli-transfer
git checkout omero_arc_importer
pip install -e .

# 4)Clone this repo 
cd ..
git clone https://github.com/MicheleBortol/arc_omero.git
cd arc_omero
pip install .
cd ..
```


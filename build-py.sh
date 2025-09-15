#!/usr/bin/bash

#(Referenced from https://github.com/jupyterlite/demo/blob/main/.github/workflows/deploy.yml)

# Fetch JupyterLite from demo repo
git clone https://github.com/jupyterlite/demo
cd demo 

# Patches for R support
curl https://github.com/sounddrill31/jupyterlite-demo/commit/4034b168f2b5ea7cf9e7f66a03c821edb121acff.patch | git am -m

# Install Deps
python -m pip install -r requirements.txt --break-system-packages
python -m pip install jupyterlite-webr  --break-system-packages

# Build it
cp README.md content
python -m jupyter lite build --contents content --output-dir dist


# Move it to dist folder to upload
mkdir -p ../docs/.vitepress/dist/jupyterlite
mv * ../docs/.vitepress/dist/jupyterlite

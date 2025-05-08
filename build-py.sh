#!/usr/bin/bash

#(Referenced from https://github.com/jupyterlite/demo/blob/main/.github/workflows/deploy.yml)

# Fetch JupyterLite from demo repo
git clone https://github.com/jupyterlite/demo
cd demo 

# Install Deps
python -m pip install -r requirements.txt --break-system-packages


# Build it
cp README.md content
jupyter lite build --contents content --output-dir dist


# Move it to dist folder to upload
mkdir -p ../docs/.vitepress/dist/jupyterlite
mv dist/* ../docs/.vitepress/dist/jupyterlite
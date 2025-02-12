#!/usr/bin/bash

# curl https://raw.githubusercontent.com/examdawn/helper_scripts/refs/heads/main/build.sh | bash

# Assume we're already in cf pages which lands us in docs folder

# cleanup
rm -rf helper-scripts/ NEP*/ contribute.md takedown.md typography.md ../node_modules || true 

# Clone sources
git clone https://github.com/examdawn/helper_scripts/ helper-scripts --depth=1 # Scripts
git clone https://github.com/examdawn/NEP_2023_BCA NEP2020/2023/BCA --depth=1 # Clone BCA

#git clone https://github.com/examdawn/NEP_2023_BCA NEP2020/2023/BSc-Math --depth=1
#git clone https://github.com/examdawn/NEP_2023_BCA NEP2020/2023/BSc-Physics --depth=1


mv helper-scripts/md/*.md . # Move the md files to current docs dir

bash helper-scripts/gen-md.sh # Create all the folders

cd .. #assume we're starting in docs folder
npm install
npm run docs:build # Build, it will pop up in 

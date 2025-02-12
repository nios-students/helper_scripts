#!/usr/bin/bash

# curl https://raw.githubusercontent.com/examdawn/helper_scripts/refs/heads/main/build.sh | bash

# Assume we're already in cf pages which lands us in docs folder

# Clone sources
git clone https://github.com/examdawn/helper_scripts/ helper_scripts
git clone https://github.com/examdawn/NEP_2023_BCA NEP2020/2023/BCA --depth=1 # Clone BCA

#git clone https://github.com/examdawn/NEP_2023_BCA NEP2020/2023/BSc-Math --depth=1
#git clone https://github.com/examdawn/NEP_2023_BCA NEP2020/2023/BSc-Physics --depth=1


mv helper-scripts/md/*.md . # Move the md files to current docs dir

bash helper-scripts/gen-md.sh # Create all the folders

cd .. #assume we're starting in docs folder
npm run docs:build # Build, it will pop up in 
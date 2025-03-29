#!/usr/bin/bash

# curl https://raw.githubusercontent.com/examdawn/helper_scripts/refs/heads/main/build.sh | bash


declare -A repos=(
  [NEP2020_2023_BCA]="https://github.com/examdawn/NEP2020_2023_BCA NEP2020/2023/BCA"
  [NEP2020_2024_BCA]="https://github.com/examdawn/NEP2020_2024_BCA NEP2020/2024/BCA"
  [NEP2020_2024_BSc]="https://github.com/examdawn/NEP2020_2024_BSc NEP2020/2024/BSc"
)
# Check if SKIP_REPO_NAME is set. If not, set it to an empty string so the script doesn't fail if it's unset.
: "${SKIP_REPO_NAME:=""}"


# Assume we're already in cf pages which lands us in docs folder

# cleanup
rm -rf helper-scripts/ contribute.md takedown.md typography.md ../node_modules .vitepress/dist || true 

# Clone sources
for repo_name in "${!repos[@]}"; do
  # Check if the current repo_name is in the SKIP_REPO_NAME variable
  if [[ "$SKIP_REPO_NAME" != *"$repo_name"* ]]; then
    echo "Cloning $repo_name..."
    target_dir="${repo_name//_//}"
    echo "Removing old directory: $target_dir..."
    rm -rf "$target_dir"
    git clone ${repos[$repo_name]} --depth=1
  else
    echo "Skipping $repo_name because it's in SKIP_$repo_name mode"
  fi
done


#git clone https://github.com/examdawn/NEP_2023_BCA NEP2020/2023/BSc-Math --depth=1
#git clone https://github.com/examdawn/NEP_2023_BCA NEP2020/2023/BSc-Physics --depth=1

git clone https://github.com/examdawn/helper_scripts
mv helper-scripts/md/*.md . # Move the md files to current docs dir

bash helper-scripts/gen-md.sh # Create all the folders

cd .. #assume we're starting in docs folder
npm install
npm run docs:build # Build, it will pop up in 
cp docs/helper-scripts/templates/template_headers docs/.vitepress/dist/_headers # Copy headers, https://vitepress-python-editor.netlify.app/installation#_4-set-http-headers
#!/bin/bash

# Base directory
base_dir="NEP2020/*/"

# Loop through each folder in NEP/2024/
for folder in "$base_dir"/*/; do
    # Check if it's a directory
    if [ -d "$folder" ]; then
        echo "Processing folder: $folder"

        # Loop through each subfolder in the current folder
        for subfolder in "$folder"/*/; do
            # Check if it's a directory
            if [ -d "$subfolder" ]; then
                echo "  Processing subfolder: $subfolder"

                # Change to the subfolder
                cd "$subfolder" || continue

                # Run the specified commands
                bash ../../../../helper-scripts/gen-assign.sh
                bash ../../../../helper-scripts/gen-lab.sh
                bash ../../../../helper-scripts/gen-solved.sh

                # Output lab.md
                echo "Outputting lab.md"
                # Assuming you want to create or modify lab.md here
                # (Add your output command here if needed)
                cat lab.md

                # Output assignment.md
                echo "Outputting assignment.md"
                # (Add your output command here if needed)
                cat assignment.md

                # Output solved.md
                echo "Outputting solved.md"
                # (Add your output command here if needed)
                cat solved.md

                # Return to the previous directory
                cd - || exit
            fi
        done
    fi
done
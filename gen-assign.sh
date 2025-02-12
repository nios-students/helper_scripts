#!/bin/bash

# Check if the current working directory ends with "sem"
if [[ "$(pwd)" != *"sem" ]]; then
    echo "Run from Semester folder"
    exit 1
fi

# Define the template file path
TEMPLATE_FILE="../../../../helper-scripts/templates/temp-assignment.md"
TMP_FILE=$(mktemp)
UNIQUE_FILE=$(mktemp)
FINAL_FILE="assignment.md"

# Cleanup function to remove temporary files
cleanup() {
    rm -f "$TMP_FILE" "$UNIQUE_FILE"
}
trap cleanup EXIT

# Check if FINAL_FILE exists
if [[ -f "$FINAL_FILE" ]]; then
    echo "Final file exists. Checking for existing entries..."
else
    echo "Final file does not exist. It will be created."
fi

# Loop through all directories in the current working directory
for folder in */; do
    # Check for index.md in the subject folder
    if [[ -f "${folder}assignments/index.md" ]]; then
        # Read the first line of index.md
        first_line=$(head -n 1 "${folder}assignments/index.md")
        
        # Check if the first line matches the expected format
        if [[ "$first_line" != "# "* ]]; then
            # Replace the first line with "# Subject:"
            echo -e "# Subject:\n$(tail -n +2 "${folder}assignments/index.md")" > "${folder}assignments/index.md"
        fi
        
        # Extract the subject name from the first line of index.md
        subject_name=$(head -n 1 "${folder}index.md" | sed 's/^# //; s/[[:space:]]*$//')  # Remove leading # and trailing whitespace
        echo "Processing ${subject_name}"
        
        # Generate the new entry
        new_entry="- [${subject_name}](${folder}assignments/index.md)"

        # Check if the entry already exists in FINAL_FILE
        if ! grep -Fxq -- "$new_entry" "$FINAL_FILE" 2>/dev/null; then
            echo "$new_entry" >> "$TMP_FILE"
        else
            echo "$new_entry already exists in FINAL_FILE. Skipping..."
        fi
    fi
done

# If there are new entries, process them for uniqueness
if [[ -s "$TMP_FILE" ]]; then
    # Check for unique entries and write them to UNIQUE_FILE
    while IFS= read -r line; do
        echo "$line" >> "$UNIQUE_FILE"
    done < "$TMP_FILE"

    # If UNIQUE_FILE has entries, append them to FINAL_FILE
    if [[ -s "$UNIQUE_FILE" ]]; then
        # If FINAL_FILE doesn't exist, copy TEMPLATE_FILE to FINAL_FILE
        if [[ ! -f "$FINAL_FILE" ]]; then
            cp "$TEMPLATE_FILE" "$FINAL_FILE"
        fi
        cat "$UNIQUE_FILE" >> "$FINAL_FILE"
    fi
fi
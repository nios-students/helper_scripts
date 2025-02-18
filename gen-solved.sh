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
FINAL_FILE="solved.md"

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
    if [[ -f "${folder}solved/index.md" ]]; then
        # Read the content of index.md
        content=$(cat "${folder}solved/index.md")

        # Check if the content starts with frontmatter
        if [[ "$(head -n 1 <<< "$content")" == "---" ]]; then
            # Find the second occurrence of "---"
            second_occurrence=$(awk '/---/{c++} c==2{print NR; exit}' <<< "$content")

            # If a second occurrence is found, skip the frontmatter
            if [[ -n "$second_occurrence" ]]; then
                start_line=$((second_occurrence + 1))
                # Extract content after frontmatter
                content=$(tail -n "+$start_line" <<< "$content")
            fi
        fi

        # Extract the subject name from the first line of index.md
        subject_name=$(sed -n 's/^# //p' "${folder}solved/index.md" | head -n 1 | sed 's/[[:space:]]*$//')  # Remove leading # and trailing whitespace
        echo "Processing ${subject_name}"

        # Generate the new entry
        new_entry="- [${subject_name}](${folder}solved/index.md)"

        # Check if the entry already exists in FINAL_FILE
        if ! grep -Fxq -- "$new_entry" "$FINAL_FILE" 2>/dev/null; then
            echo "$new_entry" >> "$TMP_FILE"
        else
            echo "$new_entry already exists in $FINAL_FILE. Skipping..."
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
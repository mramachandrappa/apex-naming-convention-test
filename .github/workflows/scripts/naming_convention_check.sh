#!/usr/bin/env bash

declare -a INVALID_FILES=()
NAME_CHECK="Passed!"

echo "REGEX_PATTERN is defined in repository variable"
echo "REGEX_PATTERN is $REGEX_PATTERN"
echo "BASE_REF is $BASE_REF"

# Get changed .object files
FILES_CHANGED=($(git diff --name-only --diff-filter=A $BASE_REF...HEAD -- "$FOLDER_NAME/*"))

if [[ ${#FILES_CHANGED[@]} -eq 0 ]]; then
    echo "No files found with changes"
    echo "INVALID_FILES=None!" >> "$GITHUB_OUTPUT"
    echo "NAME_CHECK=$NAME_CHECK" >> "$GITHUB_OUTPUT"
    exit 0
fi

echo -e "Files detected for naming convention check:\n${FILES_CHANGED[*]}\n"

# Validate naming conventions
for FILE_PATH in "${FILES_CHANGED[@]}"; do
    FILE_NAME=$(basename "$FILE_PATH")
    if [ $FOLDER_NAME = "lwc" ]; then
        FILE_NAME=$(echo "$FILE_PATH" | cut -d'/' -f2)  
    fi
    
    matched=false

    if echo "$FILE_NAME" | grep -Eq "$REGEX_PATTERN"; then
        echo "$FILE_NAME passed naming convention check."
    else
        INVALID_FILES+=("$FILE_NAME")
        echo "$FILE_NAME did NOT pass naming convention check!"
    fi
done

if [ "$ENFORCE" = true ]; then
    echo "MESSAGE=Kindly update $FOLDER_NAME as per naming convention defined." >> "$GITHUB_OUTPUT"
    exit 1
else
    echo "MESSAGE=Hey! You probably updated $FOLDER_NAME name incorrectly. Please check!" >> "$GITHUB_OUTPUT"
fi

# Output results
if [[ ${#INVALID_FILES[@]} -eq 0 ]]; then
    echo "\nAll files passed naming conventions."
    echo "INVALID_FILES=None!" >> "$GITHUB_OUTPUT"
    echo "NAME_CHECK=$NAME_CHECK" >> "$GITHUB_OUTPUT"
    echo "MESSAGE=Thanks for following naming convention check!" >> "$GITHUB_OUTPUT"
else
    echo -e "\nINVALID naming convention detected for following files!:\n${INVALID_FILES[*]}"
    NAME_CHECK="Failed!"
    echo "INVALID_FILES=${INVALID_FILES[*]}" >> "$GITHUB_OUTPUT"
    echo "NAME_CHECK=$NAME_CHECK" >> "$GITHUB_OUTPUT"
fi
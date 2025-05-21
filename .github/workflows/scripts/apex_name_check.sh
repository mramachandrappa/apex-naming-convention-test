#!/usr/bin/env bash

declare -a INVALID_FILES=()
APEX_CLS_NAME_CHECK="Passed!"

echo "REGEX_PATTERNS is defined in repository variable"
echo "REGEX_PATTERN is $REGEX_PATTERN"

# Get changed .cls files
FILES_CHANGED=($(git diff --name-only --diff-filter=A origin/main...HEAD -- '*.cls*' '*.triggers')) 

echo -e "Found the following .cls files with changes:\n${FILES_CHANGED[*]}\n"

if [[ ${#FILES_CHANGED[@]} -eq 0 ]]; then
    echo "No .cls files found with changes."
    echo "INVALID_FILES=None!" >> "$GITHUB_OUTPUT"
    echo "APEX_CLS_NAME_CHECK=$APEX_CLS_NAME_CHECK" >> "$GITHUB_OUTPUT"
    exit 0
fi

# Validate naming conventions
for FILE_PATH in "${FILES_CHANGED[@]}"; do
    FILE_NAME=$(basename "$FILE_PATH")
    matched=false

    if echo "$FILE_NAME" | grep -Eiq "$REGEX_PATTERN"; then
        echo "$FILE_NAME passed naming convention check."
    else
        INVALID_FILES+=("$FILE_NAME")
        echo "$FILE_NAME did NOT pass the naming convention check!"
    fi
done

# Output results
if [[ ${#INVALID_FILES[@]} -eq 0 ]]; then
    echo "All files passed naming conventions."
    echo "INVALID_FILES=None!" >> "$GITHUB_OUTPUT"
    echo "APEX_CLS_NAME_CHECK=$APEX_CLS_NAME_CHECK" >> "$GITHUB_OUTPUT"
else
    echo -e "Invalid Files Found:\n${INVALID_FILES[*]}"
    APEX_CLS_NAME_CHECK="Failed!"
    echo "INVALID_FILES=${INVALID_FILES[*]}" >> "$GITHUB_OUTPUT"
    echo "APEX_CLS_NAME_CHECK=$APEX_CLS_NAME_CHECK" >> "$GITHUB_OUTPUT"
    exit 1
fi
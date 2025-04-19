#!/usr/bin/env bash

declare -a INVALID_FILES=()
LWC_NAME_CHECK="Passed!"

echo "REGEX_PATTERN is defined in repository variable"
echo "REGEX_PATTERN is $REGEX_PATTERN"

REGEX_PATTERN="^[a-z]{3-5}_*"
# Get changed .cls files
FILES_CHANGED=($(git diff --name-only --diff-filter=A origin/main...HEAD -- 'lwc/*'))

echo -e "Found the following lwc components with changes:\n${FILES_CHANGED[*]}\n"

if [[ ${#FILES_CHANGED[@]} -eq 0 ]]; then
    echo "No lwc components with changes"
    echo "INVALID_FILES=None!" >> "$GITHUB_OUTPUT"
    echo "LWC_NAME_CHECK=$LWC_NAME_CHECK" >> "$GITHUB_OUTPUT"
    exit 0
fi

# Validate naming conventions
for FILE_PATH in "${FILES_CHANGED[@]}"; do
    COMPONENT_NAME=$(echo "$FILE_PATH" | cut -d'/' -f2)  
    matched=false

    if echo "$COMPONENT_NAME" | grep -Eq "$REGEX_PATTERN"; then
        echo "$COMPONENT_NAME passed LWC component naming convention check."
    else
        INVALID_FILES+=("$COMPONENT_NAME")
        echo "$COMPONENT_NAME did NOT pass LWC component naming convention check!"
    fi
done

# Output results
if [[ ${#INVALID_FILES[@]} -eq 0 ]]; then
    echo "\nAll LWC components passed naming conventions."
    echo "INVALID_FILES=None!" >> "$GITHUB_OUTPUT"
    echo "LWC_NAME_CHECK=$LWC_NAME_CHECK" >> "$GITHUB_OUTPUT"
else
    echo -e "\nINVALID LWC components name found!:\n${INVALID_FILES[*]}"
    LWC_NAME_CHECK="Failed!"
    echo "INVALID_FILES=${INVALID_FILES[*]}" >> "$GITHUB_OUTPUT"
    echo "LWC_NAME_CHECK=$LWC_NAME_CHECK" >> "$GITHUB_OUTPUT"
    exit 1
fi
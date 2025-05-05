#!/usr/bin/env bash

declare -a INVALID_FILES=()
OBJECTS_NAME_CHECK="Passed!"

echo "REGEX_PATTERN is defined in repository variable"
echo "REGEX_PATTERN is $REGEX_PATTERN"
echo "BASE_REF is $BASE_REF"

# Get changed .object files
FILES_CHANGED=($(git diff --name-only --diff-filter=A $BASE_REF...HEAD -- 'objects/*'))

echo -e "Found the following objects with changes:\n${FILES_CHANGED[*]}\n"

if [[ ${#FILES_CHANGED[@]} -eq 0 ]]; then
    echo "No objects with changes"
    echo "INVALID_FILES=None!" >> "$GITHUB_OUTPUT"
    echo "OBJECTS_NAME_CHECK=$OBJECTS_NAME_CHECK" >> "$GITHUB_OUTPUT"
    exit 0
fi

# Validate naming conventions
for FILE_PATH in "${FILES_CHANGED[@]}"; do
    OBJECTS_NAME=$(echo "$FILE_PATH" | cut -d'/' -f2)  
    matched=false

    if echo "$OBJECTS_NAME" | grep -Eq "$REGEX_PATTERN"; then
        echo "$OBJECTS_NAME passed objects naming convention check."
    else
        INVALID_FILES+=("$OBJECTS_NAME")
        echo "$OBJECTS_NAME did NOT pass objects naming convention check!"
    fi
done

# Output results
if [[ ${#INVALID_FILES[@]} -eq 0 ]]; then
    echo "\nAll objects passed naming conventions."
    echo "INVALID_FILES=None!" >> "$GITHUB_OUTPUT"
    echo "OBJECTS_NAME_CHECK=$OBJECTS_NAME_CHECK" >> "$GITHUB_OUTPUT"
else
    echo -e "\nINVALID objects name found!:\n${INVALID_FILES[*]}"
    OBJECTS_NAME_CHECK="Failed!"
    echo "INVALID_FILES=${INVALID_FILES[*]}" >> "$GITHUB_OUTPUT"
    echo "OBJECTS_NAME_CHECK=$OBJECTS_NAME_CHECK" >> "$GITHUB_OUTPUT"
    exit 1
fi
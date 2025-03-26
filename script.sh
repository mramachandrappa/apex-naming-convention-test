#!/usr/bin/env bash

REGEX_PATTERNS=( 
            "^A3C_[A-Za-z]+Test\.cls$"
            "^ABC_[A-Za-z]+Service.cls"
          )
FILES_CHANGED=($(git diff --name-only --diff-filter=AM origin/main...HEAD -- '*.cls' | xargs -I {} basename {}))

echo $FILES_CHANGED

if [ ${#FILES_CHANGED[@]} -eq 0 ]; then
    echo "No .cls files found with changes"
    exit 0
fi

EXIT_CODE=0
INVALID_FILE=()

for FILE_NAME in ${FILES_CHANGED[@]}; do
    echo "Verifying if $FILE_NAME is following Aapex class naming convention..."

    for PATTERN in ${REGEX_PATTERNS[@]}; do
        if [[ $FILE_NAME =~ $PATTERN ]]; then
            matched=true
            break
        else
            matched=false
        fi
    done

    if [ "$matched" = true ]; then
        echo "$FILE_NAME passed naming convention"
    else
        INVALID_FILES+=("$FILE_NAME")
        echo "$FILE_NAME has not passed naming convention check!"
    fi
done

if [ ${#nINVALID_FILES[@]} -eq 0 ]; then
    echo "Changes are valid!"
else
    echo "Changes are invalid!"
    exit 1
fi

echo "====\nINVALID_FILES : $INVALID_FILES"
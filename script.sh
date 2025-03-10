#!/usr/bin/env bash

REGEX_PATTERNS=( 
            "^A3C_[A-Za-z]+Test\.cls$"
            "^ABC_[A-Za-z]+Service.cls"
            "^[A-Z][A-Za-z0-9]+Helper.cls"
          )
FILES_CHANGED=$(git diff --name-only --diff-filter=AM origin/main...HEAD -- '*.cls' | xargs basename || true)

echo $FILES_CHANGED

if [ -z "$FILES_CHANGED" ]; then
    echo "No .cls files found with changes"
    exit 0
fi

EXIT_CODE=0
INVALID_FILE=()

for FILE_NAME in $FILES_CHANGED; do
    echo "Verifying if $FILE_NAME is following Aapex class naming convention..."

    for PATTERN in "$REGEX_PATTERNS"; do
        echo "PATTERN $PATTERN"
        if [[ $FILE_NAME =~ $PATTERN ]]; then
            echo "MATCHED"
            matched=true
            break
        else
            matched=false
            echo "Not Matched"
        fi
    done

    # if [ "$matched" = true ]; then
    #     $FILE_NAME passed naming convention
    # else
    #     INVALID_FILES+=("$FILE_NAME")
    #     $FILE_NAME has not passed naming convention check!
    # fi
done
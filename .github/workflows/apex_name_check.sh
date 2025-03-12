#!/usr/bin/env bash

declare -a INVALID_FILES=()
APEX_CLS_NAME_CHECK="Passed!"

REGEX_PATTERNS=( 
            "^A3A_[A-Za-z]+Testing\.cls$"
            "^ABC_[A-Za-z]+Service\.cls$"
            "^A3C_[A-Za-z]+Service\.cls$"
            )

FILES_CHANGED=($(git diff --name-only --diff-filter=AM origin/main...HEAD -- '*.cls' | xargs -I {} basename {}))

echo "Found following .cls files with change \n $FILES_CHANGED"''

if [ ${#FILES_CHANGED[@]} -eq 0 ]; then
    echo "No .cls files found with changes"
    INVALID_FILES="None!"
    exit 0
fi

for FILE_NAME in ${FILES_CHANGED[@]}; do
    for PATTERN in ${REGEX_PATTERNS[@]}; do
        if [[ $FILE_NAME =~ $PATTERN ]]; then
        matched=true
        break
        else
        matched=false
        fi
    done
    echo $matched
    if [ "$matched" ]; then
        echo "$FILE_NAME passed naming convention"
    else
        INVALID_FILES+=("$FILE_NAME")
        echo "$FILE_NAME has not passed naming convention check!"
    fi
done

if [ ${#INVALID_FILES[@]} -eq 0 ]; then
    INVALID_FILES=None!
    echo "INVALID_FILES=$INVALID_FILES" >> $GITHUB_OUTPUT
    echo "APEX_CLS_NAME_CHECK=$APEX_CLS_NAME_CHECK" >> $GITHUB_OUTPUT
else
    echo "Found Invalid Files : $INVALID_FILES"
    APEX_CLS_NAME_CHECK="Failed!"
    echo "INVALID_FILES=$INVALID_FILES" >> $GITHUB_OUTPUT
    echo "APEX_CLS_NAME_CHECK=$APEX_CLS_NAME_CHECK" >> $GITHUB_OUTPUT
    exit 1
fi
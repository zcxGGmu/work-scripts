#!/bin/bash

usage() {
    echo "Usage: $0 -d <directory> [-s <file_to_skip>]"
    exit 1
}

SKIP_FILE=""

while getopts "d:s:" opt; do
    case ${opt} in
        d )
            DIR=$OPTARG
            ;;
        s )
            SKIP_FILE=$OPTARG
            ;;
        * )
            usage
            ;;
    esac
done

if [ -z "$DIR" ]; then
    usage
fi

if [ ! -d "$DIR" ]; then
    echo "Error: Directory $DIR does not exist."
    exit 1
fi

find "$DIR" -type f -executable -not -name '*.sh' -print0 | while IFS= read -r -d '' file; do
    if [[ -n "$SKIP_FILE" && "$file" == *"$SKIP_FILE"* ]]; then
        echo "Skipping: $file (it's the file specified to be skipped)"
        continue
    fi
    
    echo "Running: $file"
    "$file"
    result=$?
    if [ $result -ne 0 ]; then
        echo "Error: Failed to execute $file with exit code $result, skipping to the next one"
        continue
    fi
done

echo "All executables ran successfully, except those reported as failed or skipped."


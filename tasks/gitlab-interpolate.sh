#!/bin/bash

set -eux

for FILE_GLOB in $FILES_GLOB; do 

    if [ -z "$VAR_PREFIX" ]; then
        echo "Please specify a VAR_PREFIX. It is required."
        exit 1
    fi

    if [ ! -d "interpolated-files" ]; then 
        mkdir interpolated-files
    fi 

    for file in $FILE_GLOB; do
        echo "interpolating $file"
        om interpolate -c "$file" --vars-env "$VAR_PREFIX" > interpolated-files/"$(basename "$file")"
    done

    DIR=$(dirname "${FILE_GLOB}")
    cp -R ./interpolated-files/*.* "${DIR}/"
    rm -rf ./interpolated-files

done
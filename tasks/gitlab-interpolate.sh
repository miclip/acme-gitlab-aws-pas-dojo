#!/bin/bash

set -eux

if [ -z "$VAR_PREFIX" ]; then
    echo "Please specify a VAR_PREFIX. It is required."
    exit 1
fi

for file in $FILES_GLOB; do
    echo "interpolating $file"
    om interpolate -c "$file" --vars-env "$VAR_PREFIX" > interpolated-files/"$(basename "$file")"
done
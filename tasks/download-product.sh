#!/bin/bash

cat /var/version && echo ""

    

    set -eux

    vars_files_args=("")
    for vf in ${VARS_FILES}
    do
      vars_files_args+=("--vars-file ${vf}")
    done

    mkdir downloaded-files pivnet-product-slug product_path stemcell_path downloaded-stemcell assign-stemcell-config

    # ${vars_files_args[@] needs to be globbed to pass through properly
    # shellcheck disable=SC2068
    om download-product \
       --config config/"${CONFIG_FILE}" ${vars_files_args[@]} \
       --output-directory downloaded-files

    { printf "\nReading product details..."; } 2> /dev/null
    # shellcheck disable=SC2068
    product_slug=$(om interpolate \
      --config config/"${CONFIG_FILE}" ${vars_files_args[@]} \
      --path /pivnet-product-slug)

    product_file=$(om interpolate \
      --config downloaded-files/download-file.json \
      --path /product_path)

    stemcell_file=$(om interpolate \
      --config downloaded-files/download-file.json \
      --path /stemcell_path?)

    { printf "\nChecking if product needs winfs injected..."; } 2> /dev/null
    if [ "$product_slug" == "pas-windows" ]; then
      TILE_FILENAME="$(basename "$product_file")"

      # The winfs-injector determines the necessary windows image,
      # and uses the CF-foundation dockerhub repo
      # to pull the appropriate Microsoft-hosted foreign layer.
      winfs-injector \
      --input-tile "$product_file" \
      --output-tile "downloaded-product/${TILE_FILENAME}"
    else
      cp "$product_file" downloaded-product
    fi

    { printf "\nChecking if stemcell was downloaded..."; } 2> /dev/null
    if [ "$stemcell_file" != "null" ]; then
      cp "$stemcell_file" downloaded-stemcell
    fi

    # code_snippet assign-stemcell-support start bash
    { printf "\nCreating a config file for assign-stemcell..."; } 2> /dev/null
    echo "product: $(om interpolate \
                       --config downloaded-files/download-file.json \
                       --path /product_slug)" \
                       > assign-stemcell-config/config.yml
    echo "stemcell: $(om interpolate \
                        --config downloaded-files/download-file.json \
                        --path /stemcell_version?)" \
                        >> assign-stemcell-config/config.yml

    { printf "\nFinished creating config file for assign-stemcell.\n"; } 2> /dev/null
    # code_snippet assign-stemcell-support end
# code_snippet download-product end
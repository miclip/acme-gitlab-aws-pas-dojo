cat /var/version && echo ""
set -eux

if [ -z "$CONFIG_FILE" ]; then
    om --env env/"${ENV_FILE}" upload-product \
        --product $PRODUCT_FILES/*.pivotal
else
    om --env env/"${ENV_FILE}" upload-product \
        --product $PRODUCT_FILES/*.pivotal --config "config/$CONFIG_FILE"
fi

product_name="$(om tile-metadata \
    --product-path ${PRODUCT_FILES}/*.pivotal \
    --product-name)"
product_version="$(om tile-metadata \
    --product-path ${PRODUCT_FILES}/*.pivotal \
    --product-version)"

om --env env/"${ENV_FILE}" stage-product \
    --product-name "$product_name" \
    --product-version "$product_version"
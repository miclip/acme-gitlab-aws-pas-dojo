cat /var/version && echo ""
set -eux

if [ -z "$CONFIG_FILE" ]; then
    om --env env/"${ENV_FILE}" upload-product \
        --product $PRODUCT_FILES/*.pivotal
else
    om --env env/"${ENV_FILE}" upload-product \
        --product $PRODUCT_FILES/*.pivotal --config "config/$CONFIG_FILE"
fi
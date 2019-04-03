cat /var/version && echo ""
set -eux
FLOATING_STEMCELL=true
om --env env/"${ENV_FILE}" upload-stemcell \
    --floating="$FLOATING_STEMCELL" \
    --stemcell $STEMCELL_DIR/*.tgz
cat /var/version && echo ""
set -eux
om --env env/"${ENV_FILE}" assign-stemcell \
    --config config/"$ASSIGN_CONFIG_FILE"
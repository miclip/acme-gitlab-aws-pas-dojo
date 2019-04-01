cat /var/version && echo ""
set -eux
om --env env/"${ENV_FILE}" configure-authentication \
    --config config/"${AUTH_CONFIG_FILE}"
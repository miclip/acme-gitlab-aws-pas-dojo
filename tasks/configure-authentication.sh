cat /var/version && echo ""
set -eux
om --env env/"${ENV_FILE}" configure-authentication \
    --config "${AUTH_CONFIG_FILE}"
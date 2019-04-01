cat /var/version && echo ""
set -eux

mkdir generated-state

vars_files_args=("")
for vf in ${VARS_FILES}
do
    vars_files_args+=("--vars-file ${vf}")
done

generated_state_path="generated-state/$(basename "$STATE_FILE")"
if [ -e "state/$STATE_FILE" ]; then
    cp "state/$STATE_FILE" "$generated_state_path"
fi

export IMAGE_FILE
IMAGE_FILE="$(find $IMAGE_FILES/*.{yml,ova,raw} 2>/dev/null | head -n1)"

if [ -z "$IMAGE_FILE" ]; then
    echo "No image file found in image input."
    echo "Contents of image input:"
    ls -al ${IMAGE_FILES}
    exit 1
fi

# ${vars_files_args[@] needs to be globbed to split properly
# shellcheck disable=SC2068
p-automator create-vm \
--config config/"${OPSMAN_CONFIG_FILE}" \
--image-file "${IMAGE_FILE}"  \
--state-file "$generated_state_path" \
${vars_files_args[@]}
# code_snippet create-vm end
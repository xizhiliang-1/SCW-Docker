#!/bin/bash -p

set -u -o pipefail

IMAGE=${MARKETING_IMAGE_PATH}
CONTAINER_NAME=${MARKETING_CONTAINER_NAME}
IMAGE_NAME=${MARKETING_IMAGE_NAME}
IMAGE_TAG=${MARKETING_IMAGE_TAG}
REBUILD_IMAGE=${REBUILD_MARKETING_IMAGE}

echo
echo "----- PROCESSING [${CONTAINER_NAME}]"
echo

. ./util/common.sh

docker run -d \
    --name ${CONTAINER_NAME} \
    --memory="512m" \
    --memory-reservation="256m" \
    --cpus="1.5" \
    --cap-drop ALL \
    --env "REPO_USERNAME=internalUser" \
    --network "${NETWORK_NAME}" \
    -v /etc/secrets/repo_password.txt:/run/secrets/repo_password:ro \
    -v /data/marketing/customer-list.csv:/data/customer-list.csv \
    --log-driver syslog \
    --log-opt syslog-address=tcp+tls://"${SYSLOG_SERVER}":"${SYSLOG_PORT}" \
    --log-opt syslog-tls-ca-cert="${SYSLOG_CA_CERT}" \
    --log-opt syslog-tls-cert="${SYSLOG_CERT}" \
    --log-opt syslog-tls-key="${SYSLOG_KEY}" \
    --log-opt tag="${IMAGE_NAME}:${IMAGE_TAG}" \
    ${IMAGE_NAME}:${IMAGE_TAG} &> /dev/null

echo "Container '${CONTAINER_NAME}' started."

echo
echo "----- DONE [${CONTAINER_NAME}]"
echo

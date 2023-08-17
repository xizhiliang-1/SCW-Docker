#!/bin/bash -p

set -u -o pipefail

IMAGE=${PROXY_IMAGE_PATH}
CONTAINER_NAME=${PROXY_CONTAINER_NAME}
IMAGE_NAME=${PROXY_IMAGE_NAME}
IMAGE_TAG=${PROXY_IMAGE_TAG}
REBUILD_IMAGE=${REBUILD_PROXY_IMAGE}

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
    -p 8443:8443 \
    --network "${NETWORK_NAME}" \
    -v /etc/ca-certificates/proxy:/etc/nginx/certs:ro \
    --log-driver syslog \
    --log-opt syslog-address=tcp+tls://"${SYSLOG_SERVER}":"${SYSLOG_PORT}" \
    --log-opt syslog-tls-ca-cert="${SYSLOG_CA_CERT}" \
    --log-opt syslog-tls-cert="${SYSLOG_CERT}" \
    --log-opt syslog-tls-key="${SYSLOG_KEY}" \
    --log-opt tag="${IMAGE_NAME}" \
    ${IMAGE_NAME}:${IMAGE_TAG} &> /dev/null

echo "Container '${CONTAINER_NAME}' started."

echo
echo "----- DONE [${CONTAINER_NAME}]"
echo

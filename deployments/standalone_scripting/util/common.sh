#!/bin/bash -p

set -u -o pipefail


docker stop ${CONTAINER_NAME} &> /dev/null
if [[ $? -ne 0 ]]; then
    echo "No container '${CONTAINER_NAME}' running."
else
    echo "Container '${CONTAINER_NAME}' stopped."
fi

docker rm ${CONTAINER_NAME} &> /dev/null
if [[ $? -ne 0 ]]; then
    echo "No container '${CONTAINER_NAME}' deleted"
else
    echo "Container '${CONTAINER_NAME}' deleted."
fi

if [[ "${REBUILD_IMAGE}" = "y" ]]; then
    docker rmi ${IMAGE_NAME}:${IMAGE_TAG} &> /dev/null
    if [[ $? -ne 0 ]]; then
        echo "No image '${IMAGE_NAME}:${IMAGE_TAG}' deleted."
    else
        echo "Image '${IMAGE_NAME}:${IMAGE_TAG}' deleted."
    fi
    docker build --no-cache ${IMAGE} -t ${IMAGE_NAME}:${IMAGE_TAG} &> /dev/null
    if [[ $? -ne 0 ]]; then
        echo "Error rebuilding image '${IMAGE_NAME}:${IMAGE_TAG}'"
        exit 1
    fi
    echo "Image '${IMAGE_NAME}:${IMAGE_TAG}' has been re-created."
fi

#!/bin/bash -p

set -u -o pipefail

## Create a private local Docker Registry service
docker service create \
    --name scw-local-registry \
    --publish published=5000,target=5000 \
    registry:2 &> /dev/null
if [[ $? -ne 0 ]]; then
    echo "Unable to create local registry."
    exit 1
fi
echo "Docker local registry created."
echo ""

## Build docker images and upload to private local registry
docker-compose build --force-rm --no-cache --quiet
if [[ $? -ne 0 ]]; then
    echo "Docker"
    exit 1
fi

docker-compose push &> /dev/null
if [[ $? -ne 0 ]]; then
    echo "Unable to push images to local registry."
    exit 1
fi
echo "Docker images pushed to local registry."
echo ""

docker stack deploy -c <(docker-compose -f docker-compose.yml config) internal-apps
if [[ $? -ne 0 ]]; then
    echo "Error deploying docker-compose.yml file"
    exit 1
fi

echo
echo "----- ALL done!"
echo

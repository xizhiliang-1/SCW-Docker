#!/bin/bash -p

set -u -o pipefail

export DOCKER_CONTENT_TRUST=1

source ../.env

usage() { 
    echo "Usage: $0 [-p] [-f] [-m]"
    echo "   -p: Rebuild the Proxy Docker image"
    echo "   -f: Rebuild the Finance app Docker image"
    echo "   -m: Rebuild the Marketing app Docker image"
    exit 1
}

while getopts ':pfm' flag; do
    case "${flag}" in
        p ) 
            REBUILD_PROXY_IMAGE="y" 
            ;;
        f ) 
            REBUILD_FINANCE_IMAGE="y" 
            ;;
        m ) 
            REBUILD_MARKETING_IMAGE="y" 
            ;;                        
        * ) 
            echo "Invalid option"
            echo ""
            usage 
            ;;
    esac
done

# NETWORK
docker network create ${NETWORK_NAME} &> /dev/null
if [[ $? -ne 0 ]]; then
    echo "Network '${NETWORK_NAME}' already exists!"
else
    echo "Network '${NETWORK_NAME}' created!"
fi

# FINANCE-APP
. ./finance-app/deploy.sh -${REBUILD_FINANCE_IMAGE}

# MARKETING-APP
. ./marketing-app/deploy.sh -${REBUILD_MARKETING_IMAGE}

# PROXY
. ./proxy/deploy.sh -${REBUILD_PROXY_IMAGE}

echo
echo "----- ALL done!"
echo

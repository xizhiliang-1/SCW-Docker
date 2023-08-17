#!/bin/sh

if [ -f "/run/secrets/repo_password" ]; then
    REPO_PASSWORD=$(cat /run/secrets/repo_password)
else
    REPO_PASSWORD=""
fi
export REPO_PASSWORD

if [ -f "/run/secrets/api_key" ]; then
    API_KEY=$(cat /run/secrets/api_key)
else
    API_KEY=""
fi
export API_KEY

/app/server

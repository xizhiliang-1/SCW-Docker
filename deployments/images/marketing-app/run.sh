#!/bin/sh

if [ -f "/run/secrets/repo_password" ]; then
    REPO_PASSWORD=$(cat /run/secrets/repo_password)
else
    REPO_PASSWORD=""
fi

export REPO_PASSWORD

python /app/server.py

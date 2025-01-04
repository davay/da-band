#!/bin/bash

if [ "$(uname)" = "Linux" ] && command -v nvidia-smi &> /dev/null; then
    echo "Starting in production mode with GPU support..."
    docker compose --profile prod up --build -d
else
    echo "Starting in development mode..."
    docker compose --profile dev up --build
fi

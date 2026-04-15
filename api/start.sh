#!/bin/bash

if [ "$(uname)" = "Linux" ] && command -v nvidia-smi &>/dev/null; then
  echo "Linux with NVIDIA GPU detected; Starting Docker in detached mode..."
  docker compose up --build -d
else
  # for macs
  echo "Not Linux; Starting UV in development mode..."
  uv run fastapi dev --host 0.0.0.0 main.py
fi

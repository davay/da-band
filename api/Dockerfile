FROM nvidia/cuda:12.8.1-cudnn-runtime-ubuntu24.04
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/
WORKDIR /app
COPY . .
EXPOSE 8000
CMD ["uv", "run", "fastapi", "run", "--host", "0.0.0.0", "main.py"]

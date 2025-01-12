# DEV 
FROM continuumio/miniconda3 AS dev
WORKDIR /app
COPY environment.yml .
RUN conda env create -f environment.yml

# Start server
COPY . .
EXPOSE 8000
CMD ["conda", "run", "-n", "da-band", "--no-capture-output", "fastapi", "dev", "--host", "0.0.0.0", "main.py"]

# PROD
FROM nvidia/cuda:12.6.3-cudnn-runtime-ubuntu24.04 AS prod
WORKDIR /app

# Install conda
RUN apt-get update && \
  apt-get install -y wget && \
  wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh && \
  bash miniconda.sh -b -p /opt/conda && \
  rm miniconda.sh
ENV PATH="/opt/conda/bin:${PATH}"

COPY environment.yml .
RUN conda env create -f environment.yml

# Start server
COPY . .
EXPOSE 8000
CMD ["conda", "run", "-n", "da-band", "--no-capture-output", "fastapi", "run", "--host", "0.0.0.0", "main.py"] 

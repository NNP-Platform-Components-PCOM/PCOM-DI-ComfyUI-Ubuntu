# syntax=docker/dockerfile:1.7
#
# PCOM-DI-ComfyUI-Ubuntu
# ComfyUI stable-diffusion UI with CUDA 12.4 support — NNP Data Ingestion namespace.

FROM pytorch/pytorch:2.4.0-cuda12.4-cudnn9-runtime

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION="0.3.10-v1"

LABEL org.opencontainers.image.title="pcom-di-comfyui-ubuntu" \
      org.opencontainers.image.description="ComfyUI with CUDA 12.4 for NNP Data Ingestion." \
      org.opencontainers.image.vendor="Nubo Native Platform" \
      org.opencontainers.image.source="https://github.com/NNP-Platform-Components-PCOM/PCOM-DI-ComfyUI-Ubuntu" \
      org.opencontainers.image.url="https://github.com/NNP-Platform-Components-PCOM/PCOM-DI-ComfyUI-Ubuntu" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.revision="${VCS_REF}" \
      org.opencontainers.image.created="${BUILD_DATE}"

RUN apt-get update && apt-get install -y --no-install-recommends \
    git wget curl libglib2.0-0 libsm6 libxrender1 libxext6 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN git clone --depth 1 https://github.com/comfyanonymous/ComfyUI.git . && \
    pip install --no-cache-dir -r requirements.txt

RUN mkdir -p models/checkpoints models/loras models/vae output input

EXPOSE 8188

CMD ["python", "main.py", "--listen", "0.0.0.0", "--port", "8188"]

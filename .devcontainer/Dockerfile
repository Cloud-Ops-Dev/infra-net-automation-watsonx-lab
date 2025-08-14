FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

# Minimal extras — rely on features for the heavy lifting
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      git make ca-certificates openssh-client curl less tini && \
    rm -rf /var/lib/apt/lists/*

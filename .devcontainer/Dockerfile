# syntax=docker/dockerfile:1
ARG UBUNTU_VERSION=24.04
FROM ubuntu:${UBUNTU_VERSION}
ARG HOST_UID=1000
ARG HOST_GID=1000

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=UTC \
    USER=vscode

# Base OS deps (+ ansible via apt; Python tooling but no pip installs here)
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl wget git unzip gnupg lsb-release software-properties-common \
    python3 python3-venv python3-dev build-essential \
    openssh-client jq make \
    ansible \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN useradd -m -s /bin/bash ${USER} && usermod -aG sudo ${USER} && \
    echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Terraform (HashiCorp APT repo)
RUN install -m 0755 -d /etc/apt/keyrings && \
    wget -O- https://apt.releases.hashicorp.com/gpg | \
      gpg --dearmor | tee /etc/apt/keyrings/hashicorp.gpg >/dev/null && \
    chmod a+r /etc/apt/keyrings/hashicorp.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/hashicorp.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
      | tee /etc/apt/sources.list.d/hashicorp.list && \
    apt-get update && apt-get install -y terraform

# AWS CLI v2
RUN curl -sSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip" && \
    unzip -q /tmp/awscliv2.zip -d /tmp && /tmp/aws/install && rm -rf /tmp/aws /tmp/awscliv2.zip

# IBM Cloud CLI
RUN curl -fsSL https://clis.cloud.ibm.com/install/linux | bash

# TFLint (latest)
RUN curl -sSL https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

# Shell niceties
RUN echo 'alias ll="ls -alF"' >> /etc/bash.bashrc

USER ${USER}
WORKDIR /workspaces

# Align container user IDs with host so bind mounts are writable
RUN groupmod -o -g ${HOST_GID} vscode && \
    usermod -o -u ${HOST_UID} -g ${HOST_GID} vscode && \
    chown -R ${HOST_UID}:${HOST_GID} /home/vscode

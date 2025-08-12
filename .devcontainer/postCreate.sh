#!/usr/bin/env bash
set -euo pipefail

cd /workspaces/infra-net-automation-watsonx-lab || cd "$PWD"

# Ensure ownership of workspace (in case prior runs created root-owned files)
if [ -d .venv ] && [ ! -w .venv ]; then
  echo "[postCreate] Fixing ownership of .venv"
  sudo chown -R "$USER":"$USER" .venv || true
fi

# Create (or recreate) project venv
if [ ! -d .venv ]; then
  echo "[postCreate] Creating Python venv"
  python3 -m venv .venv
fi

# Activate venv and install deps
. .venv/bin/activate
python -m pip install --upgrade pip
if [ -f requirements.txt ]; then
  pip install -r requirements.txt
fi

echo "== Versions =="
terraform -version || true
ansible --version || true
aws --version || true
ibmcloud -v || true
python --version || true
pip --version || true

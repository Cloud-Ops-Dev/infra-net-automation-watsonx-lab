#!/usr/bin/env bash
set -euo pipefail

# Put repo at expected workspace path
mkdir -p /workspaces
if [ ! -d "/workspaces/infra-net-automation-watsonx-lab" ]; then
  # When Dev Container attaches, it will mount the repo here automatically; no-op if already present.
  :
fi

# Create a Python venv for WatsonX scripts/notebooks (optional but clean)
cd /workspaces/infra-net-automation-watsonx-lab || cd "$PWD"
python3 -m venv .venv
. .venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt 2>/dev/null || true

# Print versions for sanity
echo "== Versions =="
terraform -version || true
ansible --version || true
aws --version || true
ibmcloud -v || true
python3 --version || true
pip --version || true

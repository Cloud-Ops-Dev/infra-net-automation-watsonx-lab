#!/usr/bin/env bash
set -euo pipefail

REPO=/workspaces/infra-net-automation-watsonx-lab
cd "$REPO" || cd "$PWD"

VENV="$HOME/.venv"

# (Re)create venv in HOME if missing
if [ ! -d "$VENV" ]; then
  echo "[postCreate] Creating Python venv at $VENV"
  python3 -m venv "$VENV"
fi

# Activate and install deps
. "$VENV/bin/activate"
python -m pip install --upgrade pip
if [ -f requirements.txt ]; then
  pip install -r requirements.txt
fi

# Convenience: write an activation helper into the repo

echo "== Versions =="
terraform -version || true
ansible --version || true
aws --version || true
ibmcloud -v || true
python --version || true
pip --version || true

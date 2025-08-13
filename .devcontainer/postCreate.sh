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
# ------------------ BEGIN aws-local bootstrap ------------------
echo "[postCreate] Syncing AWS creds to ~/.aws-local and setting env vars"

mkdir -p "$HOME/.aws-local"
for f in credentials config; do
  if [ -r "$HOME/.aws/$f" ]; then
    cp -f "$HOME/.aws/$f" "$HOME/.aws-local/$f"
  fi
done

chown -R "$USER":"$USER" "$HOME/.aws-local" 2>/dev/null || true
chmod 700 "$HOME/.aws-local" || true
[ -f "$HOME/.aws-local/config" ] && chmod 600 "$HOME/.aws-local/config" || true
[ -f "$HOME/.aws-local/credentials" ] && chmod 600 "$HOME/.aws-local/credentials" || true

if ! grep -q "BEGIN AWS_LOCAL_COPY" "$HOME/.bashrc" 2>/dev/null; then
  cat >> "$HOME/.bashrc" <<'EOS'
# BEGIN AWS_LOCAL_COPY
export AWS_SHARED_CREDENTIALS_FILE="$HOME/.aws-local/credentials"
export AWS_CONFIG_FILE="$HOME/.aws-local/config"
# END AWS_LOCAL_COPY
EOS
fi

export AWS_SHARED_CREDENTIALS_FILE="$HOME/.aws-local/credentials"
export AWS_CONFIG_FILE="$HOME/.aws-local/config"
# ------------------- END aws-local bootstrap -------------------

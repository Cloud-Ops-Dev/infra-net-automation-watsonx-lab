# -------- Makefile :: infra-net-automation-watsonx-lab --------
PY ?= python3
PIP ?= pip
VENV_DIR ?= .venv
ACTIVATE := . $(VENV_DIR)/bin/activate

# Default goal
.DEFAULT_GOAL := help

# -------- HELP SYSTEM --------
.PHONY: help
help: ## Show this help
	@echo ""
	@echo "Available Make targets:"
	@awk 'BEGIN {FS = ":.*##"; OFS="";} /^[a-zA-Z0-9_.-]+:.*##/ 	{printf "  [36m%-25s[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST) | sort
	@echo ""
	@echo "Tip: run 'make <target>' to execute a target."
help: ## Show this help
	@awk 'BEGIN{FS":.*##"; printf "\nTargets:\n"} /^[a-zA-Z0-9_.-]+:.*##/{printf "  \033[36m%-22s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

# ----- Environment -----
.PHONY: venv
venv: ## Create virtual env if missing
	test -d $(VENV_DIR) || $(PY) -m venv $(VENV_DIR)
	@echo "✓ venv ready at $(VENV_DIR)"

.PHONY: deps
deps: venv ## Install deps from pinned requirements.txt
	$(ACTIVATE); $(PIP) install --upgrade pip
	$(ACTIVATE); $(PIP) install -r requirements.txt
	@echo "✓ deps installed"

.PHONY: compile
compile: venv ## Compile requirements.txt from requirements.in (pip-tools)
	$(ACTIVATE); $(PIP) install pip-tools
	$(ACTIVATE); pip-compile --generate-hashes -o requirements.txt requirements.in
	@echo "✓ requirements.txt refreshed"

.PHONY: reset-env
reset-env: ## Blow away .venv and reinstall from requirements.txt
	rm -rf $(VENV_DIR)
	$(MAKE) deps
	@echo "✓ environment reset from requirements.txt"

.PHONY: check-env
check-env: venv ## Run basic environment checks
	$(ACTIVATE); $(PY) - <<'PYCODE'
import os, sys
need = ["IBM_CLOUD_API_KEY","WATSONX_PROJECT_ID","IBM_REGION","WATSONX_URL"]
missing = [k for k in need if not os.getenv(k)]
print("Python:", sys.version.split()[0])
print("Missing env vars:" if missing else "All required env vars present.", ", ".join(missing))
sys.exit(1 if missing else 0)
PYCODE

# ----- Code Hygiene -----
.PHONY: fmt
fmt: venv ## Format Python (best effort)
	$(ACTIVATE); $(PIP) install black >/dev/null 2>&1 || true
	$(ACTIVATE); black watsonx/ ansible/ terraform/ || true

.PHONY: lint
lint: venv ## Lint Ansible/Terraform (best effort)
	$(ACTIVATE); $(PIP) install ansible-lint >/dev/null 2>&1 || true
	ansible-lint || true
	terraform -chdir=terraform fmt -recursive
	terraform -chdir=terraform validate || true

# ----- Terraform (AWS) -----
.PHONY: tf-init tf-plan tf-apply tf-destroy
tf-init: ## Terraform init (aws)
	terraform -chdir=terraform init -upgrade

tf-plan: ## Terraform plan (aws)
	terraform -chdir=terraform plan

tf-apply: ## Terraform apply (auto-approve) (aws)
	terraform -chdir=terraform apply -auto-approve

tf-destroy: ## Terraform destroy (auto-approve) (aws)
	terraform -chdir=terraform destroy -auto-approve

# ----- Convenience -----
.PHONY: shell
shell: venv ## Open an activated shell
	@echo "Activating $(VENV_DIR). Press Ctrl-D to exit."
	@bash --rcfile <(echo "$(ACTIVATE); PS1='($(VENV_DIR)) $$PS1'")


.PHONY: test-commit
test-commit: ## Dry-run the pre-commit secret scan on staged changes
	@echo "Running pre-commit dry run on STAGED changes..."
	@git diff --cached | grep -E '^[+-].*(AWS(_|-)SECRET|AWS(_|-)ACCESS|IBM_CLOUD_API_KEY|WATSONX_.*KEY|BEGIN RSA PRIVATE KEY)[[:space:]]*=' >/dev/null && \
	 (echo "❌ Would be blocked: secret-like ASSIGNMENT found in staged diff."; exit 1) || \
	 (echo "✓ Clean: no secret-like assignments detected in staged diff."; exit 0)
test-commit: ## Dry-run the pre-commit secret scan on staged changes
	@echo "Running pre-commit dry run on STAGED changes..."
	@git diff --cached | grep -E '^[+-].*(AWS(_|-)SECRET|AWS(_|-)ACCESS|IBM_CLOUD_API_KEY|WATSONX_.*KEY|BEGIN RSA PRIVATE KEY)[[:space:]]*=' >/dev/null && \
	 (echo "❌ Would be blocked: secret-like ASSIGNMENT found in staged diff."; exit 1) || \
	 (echo "✓ Clean: no secret-like assignments detected in staged diff."; exit 0)


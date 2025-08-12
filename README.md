# Infra + Network Automation with WatsonX (Lab)

This lab provisions IBM Cloud VSI and AWS EC2 with Terraform, configures them with Ansible, and layers automation via WatsonX/WatsonX.ai. Optional Cisco simulation (EVE-NG or CML) shows network automation patterns.

## Stack
- Terraform (AWS, IBM Cloud)
- Ansible (Python, pip, SDK installs)
- WatsonX / WatsonX.ai (automation & analysis)
- Optional: Cisco EVE-NG / CML
- Dev: VScodium + Copilot Chat + WatsonX Code Assistant

## Layout
terraform/
aws/
ibm/
modules/
ansible/
inventory/
roles/common/
watsonx/
scripts/
notebooks/
cisco/
eve-ng/
cml/
docs/
diagrams/


## Goals
1. Reuse prior infra (AWS EC2 + IBM VSI) with cleaner modules.
2. Automate host configuration with Ansible.
3. Demonstrate WatsonX-driven infra/network automation.
4. Optional: drive Cisco lab tasks (config gen, checks, change plans).

## Quick start

1) Copy .env.example to .env and fill in IBM/AWS creds.
2) Build devcontainer (already done).
3) `source $HOME/.venv/bin/activate` in container.
4) `python watsonx/scripts/hello_wx.py`

Terraform: see terraform/aws and terraform/ibm.

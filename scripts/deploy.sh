#!/usr/bin/env bash
set -euo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)"
ansible-playbook -i ansible/inventory.yml ansible/playbooks/deploy.yml "$@"

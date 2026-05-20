#!/usr/bin/env bash
set -euo pipefail
REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
VAULT_FILE="$REPO_DIR/ansible/vars/vault.yml"
if [ ! -f "$VAULT_FILE" ]; then
  echo "!! No vault.yml found. Copy from vault.yml.example and edit."
  exit 1
fi
VAULT_ARGS=""
if grep -q "ANSIBLE_VAULT" "$VAULT_FILE" 2>/dev/null; then
  VAULT_ARGS="--ask-vault-pass"
fi
ansible-playbook -i "$REPO_DIR/ansible/inventory.yml" \
  "$REPO_DIR/ansible/playbooks/bootstrap.yml" $VAULT_ARGS "$@"

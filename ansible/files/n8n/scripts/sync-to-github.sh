#!/bin/bash
# n8n → GitHub workflow sync
# Exports all published workflows from n8n via API and commits to CoolDotty/n8n-workflows
#
# Config:       ~/.n8n-sync/config
# API key:      ~/.n8n-sync/api-key
# Repo:         ~/n8n-workflows
# Workflows:    ~/n8n-workflows/workflows/<id>-<slug>.json

set -euo pipefail

CONFIG_DIR="$HOME/.n8n-sync"
CONFIG_FILE="$CONFIG_DIR/config"
API_KEY_FILE="$CONFIG_DIR/api-key"
REPO_DIR="$HOME/n8n-workflows"
WORKFLOWS_DIR="$REPO_DIR/workflows"
N8N_API="http://127.0.0.1:5678/rest"

# ---------- defaults ----------
EXCLUDE_IDS=""

# ---------- load config ----------
if [ -f "$CONFIG_FILE" ]; then
  source "$CONFIG_FILE"
fi

# ---------- bail if no api key ----------
if [ ! -f "$API_KEY_FILE" ]; then
  echo "n8n-sync: no api key at $API_KEY_FILE — skipping"
  exit 1
fi
API_KEY=$(cat "$API_KEY_FILE")

# ---------- fetch workflows ----------
response=$(curl -sf "$N8N_API/workflows" \
  -H "X-N8N-API-KEY: $API_KEY") || {
  echo "n8n-sync: failed to fetch workflows from n8n API"
  exit 2
}

# ---------- ensure repo exists ----------
if [ ! -d "$REPO_DIR/.git" ]; then
  echo "n8n-sync: repo not cloned at $REPO_DIR — skipping"
  exit 3
fi

mkdir -p "$WORKFLOWS_DIR"

# ---------- export each workflow ----------
changed=0
echo "$response" | jq -c '.data[] | select(.active == true or .versionId != null)' | while read -r wf; do
  id=$(echo "$wf" | jq -r '.id')
  name=$(echo "$wf" | jq -r '.name' | tr ' /' '_-' | tr -cd 'a-zA-Z0-9_-')

  # skip excluded workflows (sync infra)
  for skip_id in $EXCLUDE_IDS; do
    if [ "$id" = "$skip_id" ]; then
      continue 2
    fi
  done

  # only export published version (active or has versionId)
  version_id=$(echo "$wf" | jq -r '.versionId // empty')
  if [ -z "$version_id" ] && [ "$(echo "$wf" | jq -r '.active')" != "true" ]; then
    continue
  fi

  # fetch full workflow detail (includes nodes, connections, etc.)
  detail=$(curl -sf "$N8N_API/workflows/$id" \
    -H "X-N8N-API-KEY: $API_KEY") || continue

  # extract the fields we want to track
  outfile="$WORKFLOWS_DIR/$id-$name.json"
  echo "$detail" | jq '{
    id: .id,
    name: .name,
    active: .active,
    nodes: .nodes,
    connections: .connections,
    settings: .settings,
    staticData: .staticData,
    tags: .tags,
    pinData: .pinData,
    versionId: .versionId
  }' > "$outfile"
done

# ---------- commit & push if changed ----------
cd "$REPO_DIR"

# pull latest first to avoid conflicts
git pull --rebase origin main 2>/dev/null || true

if ! git diff --quiet -- 'workflows/*.json'; then
  git add -A
  git commit -m "sync: n8n workflow update $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  git push origin main 2>&1 || {
    echo "n8n-sync: push failed (may need manual resolution)"
    exit 4
  }
  echo "n8n-sync: committed and pushed workflow changes"
else
  echo "n8n-sync: no workflow changes"
fi

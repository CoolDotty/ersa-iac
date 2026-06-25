#!/bin/bash
# n8n -> GitHub workflow sync
# Exports all visible workflows from n8n via API and commits to CoolDotty/n8n-workflows
#
# Config:       ~/.n8n-sync/config
# API key:      ~/.n8n-sync/api-key
# Repo:         ~/n8n-workflows
# Workflows:    ~/n8n-workflows/workflows/<id>-<slug>.json

set -euo pipefail

# Whatbox sets HOME to a non-standard path; resolve real home dir
HOME=$(cd ~ && pwd)

CONFIG_DIR="$HOME/.n8n-sync"
CONFIG_FILE="$CONFIG_DIR/config"
API_KEY_FILE="$CONFIG_DIR/api-key"
REPO_DIR="$HOME/n8n-workflows"
WORKFLOWS_DIR="$REPO_DIR/workflows"
N8N_API="http://127.0.0.1:5678/api/v1"

# ---------- defaults ----------
DEFAULT_EXCLUDE_IDS="cNyZx8zOIOcEa4WT FxOmPzb0EmlXS2YI"
EXCLUDE_IDS=""

# ---------- load config ----------
if [ -f "$CONFIG_FILE" ]; then
  source "$CONFIG_FILE"
fi
EXCLUDE_IDS=$(printf '%s\n' $DEFAULT_EXCLUDE_IDS ${EXCLUDE_IDS:-} | sort -u | xargs)

# ---------- bail if no api key ----------
if [ ! -f "$API_KEY_FILE" ]; then
  echo "n8n-sync: no api key at $API_KEY_FILE — skipping"
  exit 1
fi
API_KEY=$(cat "$API_KEY_FILE")

# ---------- fetch workflow list ----------
workflow_list=$(mktemp)
exported_ids=$(mktemp)
trap 'rm -f "$workflow_list" "$exported_ids"' EXIT

cursor=""
while true; do
  curl_args=(-sfG "$N8N_API/workflows" -H "X-N8N-API-KEY: $API_KEY" --data-urlencode "limit=100")
  if [ -n "$cursor" ]; then
    curl_args+=(--data-urlencode "cursor=$cursor")
  fi

  response=$(curl "${curl_args[@]}") || {
    echo "n8n-sync: failed to fetch workflows from n8n API"
    exit 2
  }

  echo "$response" | jq -c '.data[]' >> "$workflow_list"
  cursor=$(echo "$response" | jq -r '.nextCursor // empty')
  if [ -z "$cursor" ]; then
    break
  fi
done

# ---------- ensure repo exists ----------
if [ ! -d "$REPO_DIR/.git" ]; then
  echo "n8n-sync: repo not cloned at $REPO_DIR — skipping"
  exit 3
fi

mkdir -p "$WORKFLOWS_DIR"

# ---------- prepare repo ----------
cd "$REPO_DIR"

# set git user for cron context (no global config on Whatbox)
git config user.email "n8n-sync@x3c.ca"
git config user.name "n8n Sync"

if git show-ref --verify --quiet refs/heads/main; then
  git checkout main
else
  git checkout -b main origin/main
fi
git fetch origin main
git rebase origin/main

# ---------- export each workflow ----------
failed_details=0
while read -r wf; do
  id=$(echo "$wf" | jq -r '.id')
  name=$(echo "$wf" | jq -r '.name' | tr ' /' '_-' | tr -cd 'a-zA-Z0-9_-')

  # skip excluded workflows (sync infra)
  for skip_id in $EXCLUDE_IDS; do
    if [ "$id" = "$skip_id" ]; then
      continue 2
    fi
  done

  # fetch full workflow detail (includes nodes, connections, etc.)
  detail=$(curl -sf "$N8N_API/workflows/$id" \
    -H "X-N8N-API-KEY: $API_KEY") || {
    echo "n8n-sync: failed to export workflow $id ($name)"
    failed_details=1
    continue
  }

  # extract the fields we want to track
  outfile="$WORKFLOWS_DIR/$id-$name.json"
  find "$WORKFLOWS_DIR" -maxdepth 1 -type f -name "$id-*.json" ! -name "$(basename "$outfile")" -delete
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
  echo "$id" >> "$exported_ids"
done < "$workflow_list"

# Mirror live n8n state in the working tree. History remains in Git, but stale
# files should not look like current backups once a workflow is gone from n8n.
if [ "$failed_details" -eq 0 ]; then
  find "$WORKFLOWS_DIR" -maxdepth 1 -type f -name '*.json' -print | while read -r file; do
    base=$(basename "$file")
    id="${base%%-*}"
    if ! grep -qxF "$id" "$exported_ids"; then
      rm -f "$file"
    fi
  done
else
  echo "n8n-sync: skipped stale-file pruning because one or more workflow exports failed"
  exit 5
fi

# ---------- commit & push if changed ----------
if [ -n "$(git status --porcelain -- 'workflows/*.json')" ]; then
  git add -A -- workflows
  git commit -m "sync: n8n workflow update $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  git push origin main 2>&1 || {
    echo "n8n-sync: push failed (may need manual resolution)"
    exit 4
  }
  echo "n8n-sync: committed and pushed workflow changes"
else
  echo "n8n-sync: no workflow changes"
fi
